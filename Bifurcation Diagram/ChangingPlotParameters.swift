//
//  ChangingPlotParameters.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import SwiftUI
import Observation
@Observable class ChangingPlotParameters {
    
    //These plot parameters are adjustable
    
    var xLabel: String = ""
    var yLabel: String = ""
    var xMax : Double = 2.0
    var yMax : Double = 2.0
    var yMin : Double = -1.0
    var xMin : Double = -1.0
    var lineColor: Color = Color.blue
    var shouldIPlotPointLines = false
    var title: String = "Bifurcation Diagram"
    
}
    



