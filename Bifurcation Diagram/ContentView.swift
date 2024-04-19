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
    @State private var minX: String = "1.0"
    @State private var maxX: String = "4.0"
    
    @State var selector = 0

    var body: some View {
        VStack {
            Group {
                HStack(alignment: .center, spacing: 0) {
                    Text(plotData.plotArray[selector].changingPlotParameters.yLabel)
                        .rotationEffect(Angle(degrees: -90))
                        .foregroundColor(.red)
                        .padding()
                    VStack {
                        Chart(plotData.plotArray[selector].plotData) {
                            if plotData.plotArray[selector].changingPlotParameters.shouldIPlotPointLines {
                                LineMark(
                                    x: .value("Position", $0.xVal),
                                    y: .value("Height", $0.yVal)
                                )
                                .foregroundStyle(plotData.plotArray[selector].changingPlotParameters.lineColor)
                            }
                            PointMark(x: .value("Position", $0.xVal), y: .value("Height", $0.yVal))
                                .symbolSize(1)
                                .foregroundStyle(plotData.plotArray[selector].changingPlotParameters.lineColor)
                        }
                                                .chartXScale(domain: Double(minX)!...Double(maxX)!)
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
            
            // TextFields for changing the values of the x-min and x-max to simulate "zooming in" visually.
            HStack {
                Text("Min µ:")
                TextField("Enter min µ", text: $minX)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
               
             
            }.padding()

            HStack {
                Text("Max µ:")
                TextField("Enter max µ", text: $maxX)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
          
                
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
        guard let minXValue = Double(minX), let maxXValue = Double(maxX) else { return }
        calculator.plotDataModel = plotData.plotArray[selector]
        calculator.plotDataModel?.changingPlotParameters.xMin = minXValue
        calculator.plotDataModel?.changingPlotParameters.xMax = maxXValue
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlotClass())
    }
}

