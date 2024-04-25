import SwiftUI
import UniformTypeIdentifiers

struct TextView: View {
    
    @EnvironmentObject var plotData: PlotClass
    @State var document: TextExportDocument = TextExportDocument(message: "")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    @State var textSelectorString = "0"
    @State var textSelector = 0
    
    // Existing Text Editor dimensions
    @State private var width: CGFloat = 150
    @State private var height: CGFloat = 500
    
    // New Text Editor dimensions
    @State private var secondTextWidth: CGFloat = 150
    @State private var secondTextHeight: CGFloat = 500
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("Bifurcation Points")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextEditor(text: $plotData.plotArray[textSelector].calculatedText)
                    .frame(width: width, height: height)
                    .border(Color.gray, width: 1)
            }
            
            // Arrow Label
            Text("➔")
                .font(.largeTitle)
                .foregroundColor(.gray)

            VStack {
                Text("Feigenbaum Constants")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextEditor(text: $plotData.plotArray[textSelector].calculatedText)
                    .frame(width: secondTextWidth, height: secondTextHeight)
                    .border(Color.gray, width: 1)
            }
        }
        .padding()
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [UTType.plainText], allowsMultipleSelection: false) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                if CFURLStartAccessingSecurityScopedResource(selectedFile as CFURL) {
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else {return }
                    document.message = message
                    plotData.plotArray[0].calculatedText = message
                    CFURLStopAccessingSecurityScopedResource(selectedFile as CFURL)
                } else {
                    print("Permission error!")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .fileExporter(isPresented: $isExporting, document: document, contentType: UTType.plainText, defaultFilename: "RawData") { result in
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
        TextView().environmentObject(PlotClass())
    }
}
