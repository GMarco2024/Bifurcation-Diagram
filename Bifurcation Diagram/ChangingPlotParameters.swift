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
    
    @Published var xLabel: String = "Growth Rate (µ)"
    @Published var yLabel: String = "Attractor Population (X^*)"
    @Published var xMax: Double = 2.0
    @Published var yMax: Double = 2.0
    @Published var yMin: Double = -1.0
    @Published var xMin: Double = -1.0
    @Published var lineColor: Color = Color.blue
    @Published var title: String = "Plot Title"
    
    }
    



