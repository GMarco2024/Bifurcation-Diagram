//
//  PlotDataClass.swift
//  Charts Plot Observation
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import Foundation
import SwiftUI
import Observation

@Observable class PlotDataClass {
    
    @MainActor var plotData = [PlotDataStruct]()
    @MainActor var changingPlotParameters: ChangingPlotParameters = ChangingPlotParameters()

    init(fromLine line: Bool) {
        Task {
            await self.plotBlank()
        }
    }

    /// Displays a Blank Chart
    @MainActor func plotBlank() {
        zeroData()
        // Set the Plot Parameters for a blank state or initial view
        changingPlotParameters.yMax = 1.0
        changingPlotParameters.yMin = 0.0
        changingPlotParameters.xMax = 4.0
        changingPlotParameters.xMin = 1.0
        changingPlotParameters.xLabel = "µ"
        changingPlotParameters.yLabel = "X^*"
        changingPlotParameters.lineColor = Color.green
        changingPlotParameters.title = "Initial Plot"
    }

    /// Zeros Out The Data Being Plotted
    @MainActor func zeroData() {
        plotData = []
  
    }

    /// Append Data appends Data to the Plot.
    /// - Parameter dataPoint: Array of (x, y) data for plotting
    @MainActor func appendData(dataPoint: [(x: Double, y: Double)]) {
        for item in dataPoint {
            let dataValue: [PlotDataStruct] = [.init(xVal: item.x, yVal: item.y)]
            plotData.append(contentsOf: dataValue)
       
        }
    }
}

