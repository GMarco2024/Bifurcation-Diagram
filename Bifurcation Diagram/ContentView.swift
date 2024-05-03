import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject var plotData: PlotClass
    
    @State private var calculator = CalculatePlotData()
    @State private var selector = 0
    
    var body: some View {
        VStack {
            Group {
                
                Text("Bifurcation Diagram")
                    .font(.title)
                    .bold()
                    .underline()
                
                // Rotates the Y-axis label by -90 degrees.
                HStack(alignment: .center, spacing: 0) {
                    Text(plotData.plotArray[selector].changingPlotParameters.yLabel)
                        .rotationEffect(Angle(degrees: -90))
                        .foregroundColor(.red)
             
                // Renders a chart with line marks using the plot data.
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
                        // Displays the X-axis label.
                        Text(plotData.plotArray[selector].changingPlotParameters.xLabel)
                            .foregroundColor(.red)
                    }
                }
                .frame(alignment: .center)
            }
         
            //We have a button for plotting the logistic map
            
            Button("Plot Logistic Map") {
                Task {
                    await logisticMapFeigenbaum()
                }
            }
            .padding()
        }
    }
    
    @MainActor func setupPlotDataModel(selector: Int) {
        calculator.plotDataModel = self.plotData.plotArray[selector]
    }
    
    func logisticMapFeigenbaum() async {
        self.selector = 0
        await calculate()
        let feigenbaumDelta = await calculator.feigenbaumConstantCalculate()
        plotData.feigenbaumConstant = feigenbaumDelta
    }
    
    /// calculate
    /// Function accepts the command to start the calculation from the GUI
    func calculate() async {
        // Pass the plotDataModel to the Calculator
        await setupPlotDataModel(selector: 0)
        await calculator.plotLogisticMapBifurcation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PlotClass())
    }
}
