//
//  ContentView.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject var plotData: PlotClass
    
    @State private var calculator = CalculatePlotData()
    @State private var selector = 0
    @State private var feigenbaumDelta: Double? = nil  // State to hold the Feigenbaum constant
    
    var body: some View {
        VStack {
            Group {
                HStack(alignment: .center, spacing: 0) {
                    Text(plotData.plotArray[selector].changingPlotParameters.yLabel)
                        .rotationEffect(Angle(degrees: -90))
                        .foregroundColor(.red)
                        .padding()
                    VStack {
                        Chart(plotData.plotArray[selector].plotData) { data in
                            if plotData.plotArray[selector].changingPlotParameters.shouldIPlotPointLines {
                                LineMark(
                                    x: .value("Position", data.xVal),
                                    y: .value("Height", data.yVal)
                                )
                                .foregroundStyle(plotData.plotArray[selector].changingPlotParameters.lineColor)
                            }
                            PointMark(x: .value("Position", data.xVal), y: .value("Height", data.yVal))
                                .symbolSize(1)
                                .foregroundStyle(plotData.plotArray[selector].changingPlotParameters.lineColor)
                        }
                        .chartYScale(domain: [plotData.plotArray[selector].changingPlotParameters.yMin, plotData.plotArray[selector].changingPlotParameters.yMax])
                        .chartXScale(domain: [plotData.plotArray[selector].changingPlotParameters.xMin, plotData.plotArray[selector].changingPlotParameters.xMax])
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .padding()
                        Text(plotData.plotArray[selector].changingPlotParameters.xLabel)
                            .foregroundColor(.red)
                    }
                }
                .frame(alignment: .center)
            }
            .padding()
            
            Divider()

            HStack {
                Button("Plot Logistic Map Bifurcation", action: {
                    Task.init {
                        self.selector = 0
                        await self.calculate()
                    }
                })
                .padding()

                Button("Calculate Feigenbaum Constant", action: {
                    Task {
                            let feigenbaumDelta = await calculator.feigenbaumConstantCalculate()
                            plotData.feigenbaumConstant = feigenbaumDelta
                        }
                })
                .padding()
            }

      
             
        }
    }
    
    @MainActor func setupPlotDataModel(selector: Int) {
        calculator.plotDataModel = self.plotData.plotArray[selector]
    }
    
    /// calculate
    /// Function accepts the command to start the calculation from the GUI
    func calculate() async {
        // pass the plotDataModel to the Calculator
        await setupPlotDataModel(selector: 0)
        await calculator.plotLogisticMapBifurcation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PlotClass())
    }
}
