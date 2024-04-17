//
//  PlotDataStruct.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import Foundation
import Charts

struct PlotDataStruct: Identifiable {
    var id: Double { xVal }
    let xVal: Double
    let yVal: Double
}

