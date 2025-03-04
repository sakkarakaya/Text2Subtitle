import Foundation

class SubtitleProcessor {
    enum SubtitleError: Error {
        case fileReadError
        case fileWriteError
        case invalidFormat
    }
    
    func processSubtitle(srtPath: String, txtPath: String, outputPath: String) throws {
        guard let srtContent = try? String(contentsOfFile: srtPath, encoding: .utf8) else {
            throw SubtitleError.fileReadError
        }
        
        guard let txtContent = try? String(contentsOfFile: txtPath, encoding: .utf8) else {
            throw SubtitleError.fileReadError
        }
        
        let srtLines = srtContent.components(separatedBy: .newlines)
        let txtLines = txtContent.components(separatedBy: .newlines)
        
        var newContent = ""
        var txtIndex = 0
        var srtIndex = 0
        
        while srtIndex < srtLines.count {
            let line = srtLines[srtIndex]
            
            if line.contains("-->") {
                newContent += line + "\n"
                
                if txtIndex < txtLines.count {
                    newContent += txtLines[txtIndex].trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
                    txtIndex += 1
                } else {
                    newContent += "\n"
                }
                
                srtIndex += 1
                while srtIndex < srtLines.count && !srtLines[srtIndex].isEmpty {
                    srtIndex += 1
                }
            } else {
                newContent += line + "\n"
                srtIndex += 1
            }
        }
        
        try newContent.write(toFile: outputPath, atomically: true, encoding: .utf8)
    }
}
