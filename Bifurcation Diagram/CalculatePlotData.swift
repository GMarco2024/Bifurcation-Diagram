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
     
        plotDataModel!.changingPlotParameters.yMax = yMax
        plotDataModel!.changingPlotParameters.yMin = yMin
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = xMin
        plotDataModel!.changingPlotParameters.xLabel = xLabel
        plotDataModel!.changingPlotParameters.yLabel = yLabel
        
        // Adjust line color based on input.
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
    
   /// y represents the current value or state of the population.
   /// r is a parameter representing the groth rate.
   /// y-next is the next state of the population based on the current state and growth rate.
   /// Equation
   /// y            =  r times y times (1  -  y)
   ///  next

    func plotLogisticMapBifurcation() async {
        await resetCalculatedTextOnMainThread()
        await MainActor.run {
            plotDataModel?.zeroData()
        }
        
        // Set parameters for the bifurcation diagram range and resolution.
        let minR = 1.0
        let maxR = 4.0
        let totalSteps = 1000
        let step = (maxR - minR) / Double(totalSteps)
        var modifiedPlotData: Set<PlotPoint> = []
        
        // Calculate points for the bifurcation diagram.
        for r in stride(from: minR, through: maxR, by: step) {
          
        // Initial condition for each r value.
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

    
 //          Feigenbaum Constant
 //
 //            {x   -  x     }
 //              n      n - 1
 // [ delta  =  --------------- ]
 //             {x       -  x }
 //               n + 1      n
    
    /// Calculate Feigenbaum's constant delta
    /// - Returns: Approximation of Feigenbaum's delta constant
    
            func feigenbaumConstantCalculate() async -> Double {
                let bifurcationPoints = await fetchBifurcationPoints()
                guard bifurcationPoints.count >= 4 else {
                    print("Please plot bifurcation map first.")
                    return 0
                }

        // Calculate Feigenbaum's delta using ratios of intervals between bifurcations.
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

// Extension to provide a method for finding unique elements in an array.
        extension Array where Element: Hashable {
            func unique() -> [Element] {
                var seen: Set<Element> = []
                return filter { seen.insert($0).inserted }
            }
        }
