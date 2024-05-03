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
    
    // Array of PlotDataClass instances. This changes to this array will update any SwiftUI views observing this object.
    @Published var plotArray: [PlotDataClass]
    
    
    @Published var feigenbaumConstant: Double?
    
    // Creates an initial PlotDataClass instance configured to start with a blank plot. Initializes the plotArray with two instances of the same initial plot. This could be for showing multiple views or states of the same data set in some form.
    init() {
        let initialPlot = PlotDataClass(fromLine: true)
        self.plotArray = [initialPlot, initialPlot]
    }
}
