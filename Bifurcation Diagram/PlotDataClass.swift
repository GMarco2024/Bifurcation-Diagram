//
//  PlotDataClass.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import Foundation
import SwiftUI
import Observation

// Observable class that manages the data and settings for plotting diagrams.
@Observable class PlotDataClass {
    
    // Holds the actual plot data points as an array of PlotDataStruct.
    @MainActor var plotData = [PlotDataStruct]()
    // Manages settings for plot appearance such as axis labels, limits, and colors.
    @MainActor var changingPlotParameters: ChangingPlotParameters = ChangingPlotParameters()
    // This holds text that used for calculation
    @MainActor var calculatedText = ""
    // This tracks the number of points plotted.
    @MainActor var pointNumber = 1.0
    
    
    // Initializes the class with an option to start with a blank plot.
    init(fromLine line: Bool) {
        
        Task{
            await self.plotBlank()
            
        }
    }
    /// Displays a Blank Chart
    @MainActor func plotBlank()
    {
    // Clears any existing data.
        zeroData()
        
        // Set the Plot Parameters with initial values.
        changingPlotParameters.yMax = 1.0
        changingPlotParameters.yMin = 0.0
        changingPlotParameters.xMax = 4.0
        changingPlotParameters.xMin = 1.0
        changingPlotParameters.xLabel = "Growth Rate (µ)"
        changingPlotParameters.yLabel = "Attractor Populations (X^*)"
        changingPlotParameters.lineColor = Color.blue
        changingPlotParameters.shouldIPlotPointLines = false
        changingPlotParameters.title = "Initial PLot"
        
        
        
    }
    
    /// Zeros Out The Data Being Plotted
    @MainActor func zeroData(){
        
        // Empty the data array.
        plotData = []
        
        // Reset the point counter.
        pointNumber = 1.0
        
    }
    
    /// Append Data appends Data to the Plot. Increments the pointNumber for 1-D Data
    /// - Parameter dataPoint: Array of (x, y) data for plotting
    @MainActor func appendData(dataPoint: [(x: Double, y: Double)])
    {
        
        for item in dataPoint{
            
            let dataValue :[PlotDataStruct] =  [.init(xVal: item.x, yVal: item.y)]
            
            plotData.append(contentsOf: dataValue)
            pointNumber += 1.0
            
        }
    }
}

