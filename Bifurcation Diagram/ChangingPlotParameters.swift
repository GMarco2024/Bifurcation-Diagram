//
//  ChangingPlotParameters.swift
//  Charts Plot Observation
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import SwiftUI
import Combine

@MainActor
class ChangingPlotParameters: ObservableObject {
    
    // These plot parameters are adjustable and can be dynamically updated
    
    @Published var xLabel: String = "x"
    @Published var yLabel: String = "y"
    @Published var xMax: Double = 2.0
    @Published var yMax: Double = 2.0
    @Published var yMin: Double = -1.0
    @Published var xMin: Double = -1.0
    @Published var lineColor: Color = Color.blue
    @Published var title: String = "Plot Title"
    
    // Init to allow easy resetting to default values or setting initial values
    init(xLabel: String = "x", yLabel: String = "y", xMax: Double = 2.0, yMax: Double = 2.0, yMin: Double = -1.0, xMin: Double = -1.0, lineColor: Color = Color.blue, title: String = "Plot Title") {
        self.xLabel = xLabel
        self.yLabel = yLabel
        self.xMax = xMax
        self.yMax = yMax
        self.yMin = yMin
        self.xMin = xMin
        self.lineColor = lineColor
        self.title = title
    }
    
    // Function to reset parameters to default or initial values
    func resetParameters() {
        xLabel = "x"
        yLabel = "y"
        xMax = 2.0
        yMax = 2.0
        yMin = -1.0
        xMin = -1.0
        lineColor = .blue
        title = "Plot Title"
    }
}

