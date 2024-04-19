//
//  ContentView.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  MOdified by Marco Gonzalez
//

import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject var plotData: PlotClass
    
    @State private var calculator = CalculatePlotData()
    @State private var minX: Double = 1.0
    @State private var maxX: Double = 4.0
    
    @State var selector = 0

    var body: some View {
        VStack {
            Group {
                HStack(alignment: .center, spacing: 0) {
                    Text($plotData.plotArray[selector].changingPlotParameters.yLabel.wrappedValue)
                        .rotationEffect(Angle(degrees: -90))
                        .foregroundColor(.red)
                        .padding()
                    VStack {
                        Chart($plotData.plotArray[selector].plotData.wrappedValue) {
                            
                            
                            if ($plotData.plotArray[selector].changingPlotParameters.shouldIPlotPointLines.wrappedValue) {
                                                            LineMark(
                                                                x: .value("Position", $0.xVal),
                                                                y: .value("Height", $0.yVal)
                                                            )
                                                            .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)}
                                                        PointMark(x: .value("Position", $0.xVal), y: .value("Height", $0.yVal))
                                                        
                                                            .symbolSize( 1 )
                                                        
                                                            .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                        }
                        .chartXScale(domain: minX...maxX)
                        .chartYScale(domain: [
                            plotData.plotArray[selector].changingPlotParameters.yMin,
                            plotData.plotArray[selector].changingPlotParameters.yMax
                        ])
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .padding()
                        Text(plotData.plotArray[selector].changingPlotParameters.xLabel)
                            .foregroundColor(.red)
                    }
                }
                .frame(height: 300)
            }
            .padding()

            Divider()
            
            
            //Sliders for changing the values of the x-min and x-max to simulate "zooming in" visually.

            HStack {
                Text("Min µ:")
                Slider(value: $minX, in: 1.0...maxX)
                Text("\(minX, specifier: "%.2f")")
            }.padding()

            HStack {
                Text("Max µ:")
                Slider(value: $maxX, in: minX...4.0)
                Text("\(maxX, specifier: "%.2f")")
            }.padding()

            Button("Plot Logistic Map Bifurcation") {
                Task {
                    await calculate()
                }
            }
            .padding()
        }
    }

    func calculate() async {
        await setupPlotDataModel()
        await calculator.plotLogisticMapBifurcation()
    }
    
    @MainActor func setupPlotDataModel() {
        calculator.plotDataModel = plotData.plotArray[selector]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlotClass())
    }
}
