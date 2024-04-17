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
    @MainActor var calculatedText = ""
    @MainActor var pointNumber = 1.0
    
    init(fromLine line: Bool) {
        
        Task{
            await self.plotBlank()
            
        }
        
       }
    
    
    
    /// Displays a Blank Chart
    @MainActor func plotBlank()
    {
        zeroData()
        
        //set the Plot Parameters
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
            
            plotData = []
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

