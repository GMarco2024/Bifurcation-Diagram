//
//  TextView.swift
//  Bifurcation Diagram
//
//  Created by Jeff_Terry on 1/15/24.
//  Modified by Marco Gonzalez 2/11/24
//

import SwiftUI

struct TextView: View {
    
    @EnvironmentObject var plotData: PlotClass
    
    // Dimensions for the text editors
    @State private var width: CGFloat = 150
    @State private var height: CGFloat = 500
    @State private var secondTextWidth: CGFloat = 150
    @State private var secondTextHeight: CGFloat = 50
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("Bifurcation Points")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextEditor(text: $plotData.plotArray[0].calculatedText)
                    .frame(width: width, height: height)
                
            }

            VStack {
                Text("➔")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }

            VStack {
                Text("Calculated Feigenbaum Constant")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextEditor(text: Binding(
                    get: {
                        if let feigenbaumConstant = plotData.feigenbaumConstant {
                            return "\(feigenbaumConstant)"
                        } else {
                            return "Feigenbaum constant will appear here."
                        }
                    },
                    set: { _ in }
                ))
                .frame(width: secondTextWidth, height: secondTextHeight)
   
            }
        }
        .padding()
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView().environmentObject(PlotClass())
    }
}
