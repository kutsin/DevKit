import Foundation

public extension URL {
    var uniqueURL: URL {
        assert(isFileURL)
        return _uniqueURL
    }
    
    private var _uniqueURL: URL {
        if FileManager.default.fileExists(atPath: path) {
            var fileURL = self
            let pathExtension = fileURL.pathExtension
            fileURL.deletePathExtension()
            var pathComponents = fileURL.lastPathComponent.components(separatedBy: " ")
            fileURL.deleteLastPathComponent()
            
            let fileNumber: Int
            
            if let lastPathComponent = pathComponents.last, pathComponents.count > 1,
               let number = Int(lastPathComponent) {
                pathComponents.removeLast()
                fileNumber = number + 1
            } else {
                fileNumber = 1
            }
            
            let pathComponent = pathComponents
                .joined(separator: " ")
                .appending(" \(fileNumber)")
            return fileURL.appendingPathComponent(pathComponent)
                .appendingPathExtension(pathExtension)
                ._uniqueURL
        }
        return self
    }
}
