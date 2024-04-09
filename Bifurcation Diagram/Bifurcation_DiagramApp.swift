//
//  Bifurcation_DiagramApp.swift
//  Bifurcation Diagram
//
//  Created by Marco Gonzalez on 4/9/24.
//

import SwiftUI

@main
struct Bifurcation_DiagramApp: App {
    
    @State var plotData = PlotClass()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(plotData)
        }
    }
}
