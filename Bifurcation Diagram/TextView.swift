//
//  TextView.swift
//  Bifurcation Diagram
//  Tab for Displaying and saving text
//
//  Created by Jeff Terry on 1/23/21.
//  Modified by Marco Gonzalez 2/11/24
//

import SwiftUI
import UniformTypeIdentifiers

struct TextView: View {
    
    @EnvironmentObject var plotData: PlotClass
    
    @State var document: TextExportDocument = TextExportDocument(message: "")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    @State var textSelectorString = "0"
    @State var textSelector = 0
    
    var body: some View {
        VStack {
            TextEditor(text: $plotData.plotArray[textSelector].calculatedText)
            
            
            
            
            
        }
        .padding()
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                
                // Trying to get access to URL contents
                if CFURLStartAccessingSecurityScopedResource(selectedFile as CFURL) 
                
                
                
                
                {
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else {return }
                    document.message = message
                    plotData.plotArray[0].calculatedText = message
                    
                    
                    
                    // Done accessing the URL
                    CFURLStopAccessingSecurityScopedResource(selectedFile as CFURL)
                } else {
                    print("Permission error!")
                }
            } catch {
                // Handle failure.
                print(error.localizedDescription)
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: UTType.plainText,
            defaultFilename: "RawData"
        ) { result in
            if case .success = result {
                // Handle success.
            } else {
                // Handle failure.
            }
        }
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
        .environmentObject(PlotClass())
    }
}
