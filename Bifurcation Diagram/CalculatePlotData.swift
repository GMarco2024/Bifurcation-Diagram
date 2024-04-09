//
//  CalculatePlotData.swift
//  Charts Plot Observation
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CalculatePlotData: ObservableObject {
    
    @Published var plotDataModel: PlotDataClass? = nil
    
    /// Plots the bifurcation diagram for the logistic map.
    func plotLogisticMapBifurcation() async {
        let minR = 0.0
        let maxR = 4.0
        let step = 0.01
        var plotData: [(x: Double, y: Double)] = []

        for r in stride(from: minR, through: maxR, by: step) {
            var y = 0.5  // Start with an arbitrary seed

            // Discard initial transient values to allow the system to stabilize
            for _ in 1...200 {
                y = r * y * (1 - y)
            }

            // Calculate a subset of the next iterations to capture the system's behavior
            for _ in 201...300 {
                y = r * y * (1 - y)
                plotData.append((x: r, y: y))
            }
        }

        // Set plot parameters and append the data to be plotted
        await setThePlotParameters(color: "Blue", xLabel: "Rate (r)", yLabel: "Population (y)", title: "Bifurcation Diagram", xMin: minR, xMax: maxR, yMin: 0.0, yMax: 1.0)
        await appendDataToPlot(plotData: plotData)
    }
    
    /// Sets the parameters for the plot based on inputs.
    func setThePlotParameters(color: String, xLabel: String, yLabel: String, title: String, xMin: Double, xMax: Double, yMin:Double, yMax:Double) async {
        guard let plotDataModel = plotDataModel else { return }
        
        // Set the plot parameters
        plotDataModel.changingPlotParameters.yMax = yMax
        plotDataModel.changingPlotParameters.yMin = yMin
        plotDataModel.changingPlotParameters.xMax = xMax
        plotDataModel.changingPlotParameters.xMin = xMin
        plotDataModel.changingPlotParameters.xLabel = xLabel
        plotDataModel.changingPlotParameters.yLabel = yLabel
        
        if color == "Red"{
            plotDataModel.changingPlotParameters.lineColor = .red
        } else {
            plotDataModel.changingPlotParameters.lineColor = .blue
        }
        plotDataModel.changingPlotParameters.title = title
        
        plotDataModel.zeroData()
    }
    
    /// Appends the generated data points to the plot.
    func appendDataToPlot(plotData: [(x: Double, y: Double)]) async {
        guard let plotDataModel = plotDataModel else { return }
        plotDataModel.appendData(dataPoint: plotData)
    }
}
