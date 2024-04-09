//
//  ChangingPlotParameters.swift
//  Charts Plot Observation
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import SwiftUI
import Observation
@Observable class ChangingPlotParameters {
    
    //These plot parameters are adjustable
    
    var xLabel: String = "x"
    var yLabel: String = "y"
    var xMax : Double = 2.0
    var yMax : Double = 2.0
    var yMin : Double = -1.0
    var xMin : Double = -1.0
    var lineColor: Color = Color.blue
    var title: String = "Plot Title"
    
}
