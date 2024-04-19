//
//  PlotPoint.swift
//  Bifurcation Diagram
//
//  Created by PHYS 440 Marco on 4/19/24.
//

// PlotPoint.swift

import Foundation

// This defines a structure that represents a point in the 2D space of the plot in which conforms to `Hashable` to ensure it can be stored.

struct PlotPoint: Hashable {
    let x: Double
    let y: Double
}
