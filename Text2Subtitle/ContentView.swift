//
//  ContentView.swift
//  Text2Subtitle
//
//  Created by Mehmet Karakaya on 04.03.25.
//

import SwiftUI

struct ContentView: View {
    @State private var srtURL: URL?
    @State private var txtURL: URL?
    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let processor = SubtitleProcessor()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SRT Metin Düzenleyici")
                .font(.title)
            
            FilePickerButton(url: $srtURL, title: "SRT Dosyası Seç", fileType: "srt")
            FilePickerButton(url: $txtURL, title: "TXT Dosyası Seç", fileType: "txt")
            
            if srtURL != nil && txtURL != nil {
                Button(action: processFiles) {
                    if isProcessing {
                        ProgressView()
                    } else {
                        Text("İşlemi Başlat")
                    }
                }
                .disabled(isProcessing)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .alert("İşlem Durumu", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func processFiles() {
        guard let srtURL = srtURL, let txtURL = txtURL else { return }
        
        isProcessing = true
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.init(filenameExtension: "srt")!]
        savePanel.nameFieldStringValue = "yeni_altyazi.srt"
        
        savePanel.begin { response in
            if response == .OK, let outputURL = savePanel.url {
                do {
                    try processor.processSubtitle(
                        srtPath: srtURL.path,
                        txtPath: txtURL.path,
                        outputPath: outputURL.path
                    )
                    alertMessage = "Altyazı dosyası başarıyla oluşturuldu!"
                } catch {
                    alertMessage = "Hata: \(error.localizedDescription)"
                }
                showAlert = true
            }
            isProcessing = false
        }
    }
}

struct FilePickerButton: View {
    @Binding var url: URL?
    let title: String
    let fileType: String
    
    var body: some View {
        HStack {
            Button(title) {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.allowedContentTypes = [.init(filenameExtension: fileType)!]
                
                if panel.runModal() == .OK {
                    url = panel.url
                }
            }
            
            if let url {
                Text(url.lastPathComponent)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
