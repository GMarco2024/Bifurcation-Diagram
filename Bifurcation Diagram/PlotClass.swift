//
//  PlotClass.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//


import Foundation
import Observation

@Observable class PlotClass {
    
    var plotArray = [PlotDataClass.init(fromLine: true)]
    
    init() {
        self.plotArray = [PlotDataClass.init(fromLine: true)]
        self.plotArray.append(contentsOf: [PlotDataClass.init(fromLine: true)])
            
        }
}
