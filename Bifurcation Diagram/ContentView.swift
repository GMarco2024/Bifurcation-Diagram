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
    @State private var muMin: Double = 1.0
    @State private var muMax: Double = 4.0
    
    var body: some View {
        VStack {
            Text("Bifurcation Diagram")
                .font(.title)
                .bold()
                .underline()
            
            HStack(alignment: .center, spacing: 0) {
                Text(plotData.plotArray[selector].changingPlotParameters.yLabel)
                    .rotationEffect(Angle(degrees: -90))
                    .foregroundColor(.red)
                VStack {
                    Chart(plotData.plotArray[selector].plotData) { data in
                        if plotData.plotArray[selector].changingPlotParameters.shouldIPlotPointLines {
                            LineMark(
                                x: .value("Position", data.xVal),
                                y: .value("Height", data.yVal)
                            )
                            .foregroundStyle(plotData.plotArray[selector].changingPlotParameters.lineColor)
                        }
                        PointMark(
                            x: .value("Position", data.xVal),
                            y: .value("Height", data.yVal)
                        )
                        .symbolSize(1)
                        .foregroundStyle(plotData.plotArray[selector].changingPlotParameters.lineColor)
                    }
                    .chartYScale(domain: [plotData.plotArray[selector].changingPlotParameters.yMin, plotData.plotArray[selector].changingPlotParameters.yMax])
                    .chartXScale(domain: [muMin, muMax])
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    Text(plotData.plotArray[selector].changingPlotParameters.xLabel)
                        .foregroundColor(.red)
                }
            }
            .frame(alignment: .center)

            // Sliders for adjusting muMin and muMax
            HStack {
                VStack {
                    Text("Min µ: \(muMin, specifier: "%.2f")")
                        .foregroundColor(.red)
                    Slider(value: $muMin, in: 1...muMax, step: 0.01)
                }
                VStack {
                    Text("Max µ: \(muMax, specifier: "%.2f")")
                        .foregroundColor(.red)
                    Slider(value: $muMax, in: muMin...4, step: 0.01)
                }
            }
            .padding()

            Button("Plot Logistic Map") {
                Task {
                    await logisticMapFeigenbaum()
                }
            }
            .padding()
        }
    }
    
    func logisticMapFeigenbaum() async {
        self.selector = 0
        await calculate()
        let feigenbaumDelta = await calculator.feigenbaumConstantCalculate()
        plotData.feigenbaumConstant = feigenbaumDelta
    }
    
    @MainActor func setupPlotDataModel(selector: Int) {
        calculator.plotDataModel = self.plotData.plotArray[selector]
    }
    
    func calculate() async {
        await setupPlotDataModel(selector: 0)
        await calculator.plotLogisticMapBifurcation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PlotClass())
    }
}

