//
//  CalculatePlotData.swift
//  Charts Plot Observation
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//
// The following is based off the "Bugs.java: Bifurcation diagram for logistic map" code from page 294.
//

import Foundation
import SwiftUI
import Observation


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
    @MainActor func setThePlotParameters(color: String, xLabel: String, yLabel: String, title: String, xMin: Double, xMax: Double, yMin:Double, yMax:Double) {
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = yMax
        plotDataModel!.changingPlotParameters.yMin = yMin
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = xMin
        plotDataModel!.changingPlotParameters.xLabel = xLabel
        plotDataModel!.changingPlotParameters.yLabel = yLabel
        
        if color == "Red"{
            plotDataModel!.changingPlotParameters.lineColor = Color.red
        }
        else{
            
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
    
  
    
    func plotLogisticMapBifurcation() async {
        let minR = 1.0
        let maxR = 4.0
        
        //Total number of steps
        let totalSteps = 1000
        
        // This calculates the step size
        let step = (maxR - minR) / Double(totalSteps)
        var plotData: [(x: Double, y: Double)] = []
        var theText = "Growth Rate (µ), Attractor Populations (X^*)"
        
        
        //mu loop. In this case, mu is r.
        for r in stride(from: minR, through: maxR, by: step) {
            
        // Arbituary seed
            var y = 0.5

        // Transients
            for _ in 1...200 {
                y = r * y * (1 - y)
            }

            // Calculates stable points for display and plotting. The first 200 are skipped.
            
            for _ in 201...401 {
                y = r * y * (1 - y)
                plotData.append((x: r, y: y))
                theText += "\(r), \(y)\n"
            }
        }

        // Set plot parameters
        await setThePlotParameters(color: "Blue", xLabel: "Growth Rate (µ)", yLabel: "Attractor Population (X^*)", title: "Logistic Map Bifurcation", xMin: minR, xMax: maxR, yMin: 0, yMax: 1)

        // Append the data to the plot and update the text
        await appendDataToPlot(plotData: plotData)
        await updateCalculatedTextOnMainThread(theText: theText)
    }

    
    
    /// Resets the Calculated Text to ""
        @MainActor func resetCalculatedTextOnMainThread() {
            //Print Header
            plotDataModel!.calculatedText = ""
    
        }
    
    
    /// Adds the passed text to the display in the main window
    /// - Parameter theText: Text Passed To Add To Display
        @MainActor func updateCalculatedTextOnMainThread(theText: String) {
            //Print Header
            plotDataModel!.calculatedText += theText
        }
    
}


