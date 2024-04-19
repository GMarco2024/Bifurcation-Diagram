//
//  PlotClass.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//


import Foundation
import SwiftUI

class PlotClass: ObservableObject {
    
    @Published var plotArray: [PlotDataClass]

    init() {
        let initialPlot = PlotDataClass(fromLine: true)
        self.plotArray = [initialPlot, initialPlot]
    }
}
