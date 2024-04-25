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
    @State private var width: CGFloat = 350
    @State private var height: CGFloat = 500
    
    // New Text Editor dimensions
    @State private var secondTextWidth: CGFloat = 300
    @State private var secondTextHeight: CGFloat = 500
    
    var body: some View {
        HStack(spacing: 20) {
            TextEditor(text: $plotData.plotArray[textSelector].calculatedText)
                .frame(width: width)
                .border(Color.gray, width: 1)

            // Arrow Label
            Text("➔")
                .font(.largeTitle)
                .foregroundColor(.gray)

            // Second Text Editor (Test)
            TextEditor(text: $plotData.plotArray[textSelector].calculatedText)
                .frame(width: secondTextWidth)
                .border(Color.blue, width: 1)
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
