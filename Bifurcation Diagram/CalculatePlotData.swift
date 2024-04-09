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
import Combine

@MainActor
class CalculatePlotData: ObservableObject {
    
    @Published var plotDataModel: PlotDataClass? = nil
    
    /// Plots the bifurcation diagram for the logistic map.
 
    
    // These are the class variables
    
    func plotLogisticMapBifurcation() async {
        let minR = 1.0
        let maxR = 4.0
        let step = 0.01
        var plotData: [(x: Double, y: Double)] = []
        
        //mu loop
        
        for r in stride(from: minR, through: maxR, by: step)
        
        {
            
            //Arbituary seed
            var y = 0.5
            
            // Transients
            for _ in 1...200 {
                y = r * y * (1 - y)
            }
            
            for _ in 201...401 {
                y = r * y * (1 - y)
                plotData.append((x: r, y: y))
            }
        }
        
        // Append the data to be plotted
        await appendDataToPlot(plotData: plotData)
    }
    
    /// Appends the generated data points to the plot.
    func appendDataToPlot(plotData: [(x: Double, y: Double)]) async {
        guard let plotDataModel = plotDataModel else { return }
        plotDataModel.appendData(dataPoint: plotData)
    }
}

