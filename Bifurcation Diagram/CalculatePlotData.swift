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
    
  
    //This function is of the bifurcation diagram. Modified from the Java code form Chapter 12 on Chaos.
    func plotLogisticMapBifurcation() async {
        let minR = 1.0
        let maxR = 4.0
        
    //Total steps in which are looped.
        let totalSteps = 1000
        let step = (maxR - minR) / Double(totalSteps)
        var plotData: [(x: Double, y: Double)] = []
        var theText = "µ, X^*"
        
        //mu loop. In this case, mu is r.
        for r in stride(from: minR, through: maxR, by: step) {
            
            
       //Arbituary Seed
            var y = 0.5
            
       //Transients
            for _ in 1...200 {
                y = r * y * (1 - y)
            }
            
            for _ in 201...401 {
                y = r * y * (1 - y)
                
    // We let decimalR and decimalY be the modifications for the lited text in which the values are set to 4 decimal places.
                
                let decimalR = Double(round(10000 * r) / 10000)
                let decimalY = Double(round(10000 * y) / 10000)
                plotData.append((x: decimalR, y: decimalY))
                theText += "\(decimalR), \(decimalY)\n"
                
            }
        }

        //Append the data to be plotted of course.
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


