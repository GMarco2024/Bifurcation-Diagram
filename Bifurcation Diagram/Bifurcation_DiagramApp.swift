//
//  Bifurcation_DiagramApp.swift
//  Bifurcation Diagram
//
//  Created by Marco Gonzalez on 4/9/24.
//

import SwiftUI
import Observation

@main
struct Bifurcation_DiagramApp: App {
    
    // I had to create this instance for PlotClass that will be passed as EnvironmentObject
    var plotData = PlotClass()

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .environmentObject(plotData)
                    .tabItem {
                        Label("Bifurcation Plot", systemImage: "chart.xyaxis.line")
                    }
                TextView()
                    .environmentObject(plotData)
                    .tabItem {
                        Label("Bifurcation Plot Points", systemImage: "text.alignleft")
                }
            }
        }
    }
}
