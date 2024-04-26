//
//  CalculatePlotData.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//
//  The following is based off the "Bugs.java: Bifurcation diagram for logistic map" code from page 294.
//

import Foundation
import SwiftUI

@Observable class CalculatePlotData {
    
    var plotDataModel: PlotDataClass? = nil
    var theText = ""
    
    /// Set the Plot Parameters
    /// - Parameters:
    ///   - color: Color of the Plotted Data
    ///   - xLabel: x Axis Label
    ///   - yLabel: y Axis Label
    ///   - title: Title of the Plot
    ///   - xMin: Minimum value of x Axis
    ///   - xMax: Maximum value of x Axis
    ///   - yMin: Minimum value of y Axis
    ///   - yMax: Maximum value of y Axis
    @MainActor func setThePlotParameters(color: String, xLabel: String, yLabel: String, title: String, xMin: Double, xMax: Double, yMin: Double, yMax: Double) {
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = yMax
        plotDataModel!.changingPlotParameters.yMin = yMin
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = xMin
        plotDataModel!.changingPlotParameters.xLabel = xLabel
        plotDataModel!.changingPlotParameters.yLabel = yLabel
        
        if color == "Red" {
            plotDataModel!.changingPlotParameters.lineColor = Color.red
        } else {
            plotDataModel!.changingPlotParameters.lineColor = Color.blue
        }
        plotDataModel!.changingPlotParameters.title = title
        
        plotDataModel!.zeroData()
    }
    
    /// This appends data to be plotted to the plot array
    /// - Parameter plotData: Array of (x, y) points to be added to the plot
    @MainActor func appendDataToPlot(plotData: [(x: Double, y: Double)]) {
        plotDataModel!.appendData(dataPoint: plotData)
    }
    
    // This function calculates the bifurcation diagram. Modified from the Java code form Chapter 12 on Chaos.
    func plotLogisticMapBifurcation() async {
        await resetCalculatedTextOnMainThread()
        
      
        await MainActor.run {
            plotDataModel?.zeroData()
        }
        
        let minR = 1.0
        let maxR = 4.0
        let totalSteps = 1000
        let step = (maxR - minR) / Double(totalSteps)
        var modifiedPlotData: Set<PlotPoint> = []
        
        for r in stride(from: minR, through: maxR, by: step) {
            var y = 0.5
            for _ in 1...1000 {
                y = r * y * (1 - y)
            }
            for _ in 1001...2000 {
                y = r * y * (1 - y)
                let decimalR = Double(round(10000 * r) / 10000)
                let decimalY = Double(round(10000 * y) / 10000)
                modifiedPlotData.insert(PlotPoint(x: decimalR, y: decimalY))
            }
        }
        let sortedPlotData = Array(modifiedPlotData).sorted { $0.x < $1.x }
        var theText = "µ, X^*\n"
        for point in sortedPlotData {
            theText += "\(point.x), \(point.y)\n"
        }
                await appendDataToPlot(plotData: sortedPlotData.map { ($0.x, $0.y) })
                await updateCalculatedTextOnMainThread(theText: theText)
            }

            /// Resets the Calculated Text to ""
            @MainActor func resetCalculatedTextOnMainThread() {
                plotDataModel!.calculatedText = ""
            }

            /// Adds the passed text to the display in the main window
            /// - Parameter theText: Text Passed To Add To Display
            @MainActor func updateCalculatedTextOnMainThread(theText: String) {
                plotDataModel!.calculatedText += theText
            }

            /// Calculate Feigenbaum's constant delta
            /// - Returns: Approximation of Feigenbaum's delta constant
            func feigenbaumConstantCalculate() async -> Double {
                let bifurcationPoints = await fetchBifurcationPoints()
                guard bifurcationPoints.count >= 4 else {
                    print("Not enough bifurcation points to calculate Feigenbaum's constant.")
                    return 0
                }

                var deltas = [Double]()
                for i in 2..<(bifurcationPoints.count - 1) {
                    let ratio = (bifurcationPoints[i] - bifurcationPoints[i - 1]) / (bifurcationPoints[i + 1] - bifurcationPoints[i])
                    deltas.append(ratio)
                }

                return deltas.last ?? 0
            }

            /// Fetch bifurcation points from the model
            /// - Returns: An array of growth rate values where bifurcations occur
            private func fetchBifurcationPoints() async -> [Double] {
                await MainActor.run {
                    return plotDataModel?.plotData.compactMap { $0.xVal }.unique() ?? []
                }
            }
        }

        extension Array where Element: Hashable {
            func unique() -> [Element] {
                var seen: Set<Element> = []
                return filter { seen.insert($0).inserted }
            }
        }
