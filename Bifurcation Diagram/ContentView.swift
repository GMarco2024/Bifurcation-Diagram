//
//  ContentView.swift
//  Charts Plot Observation
//
//  Created by Jeff_Terry on 1/15/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject var plotData: PlotClass
    
    @State private var calculator = CalculatePlotData()
    
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
                                .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                            }
                            PointMark(x: .value("Position", $0.xVal), y: .value("Height", $0.yVal))
                                .symbolSize(1)
                                .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                        }
                        .chartYScale(domain: [plotData.plotArray[selector].changingPlotParameters.yMin, plotData.plotArray[selector].changingPlotParameters.yMax])
                        .chartXScale(domain: [plotData.plotArray[selector].changingPlotParameters.xMin, plotData.plotArray[selector].changingPlotParameters.xMax])
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .padding()
                        Text($plotData.plotArray[selector].changingPlotParameters.xLabel.wrappedValue)
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

                Button("FeigenbaumPrinciple Plot", action: {
                    Task.init {
                        self.selector = 1
                        await self.calculate2()
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
        let _ = await withTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {
                // Calculate the new plotting data and place in the plotDataModel
                await calculator.plotLogisticMapBifurcation()
            }
        }
    }

    /// calculate2
    /// Function for calculating the exp(-x) plot
    func calculate2() async {
        // pass the plotDataModel to the Calculator
        await setupPlotDataModel(selector: 1)
        let _ = await withTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {
                // Calculate the new plotting data for exp(-x)
                await calculator.feigenbuamPrinciplePlot()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(PlotClass())
    }
}
