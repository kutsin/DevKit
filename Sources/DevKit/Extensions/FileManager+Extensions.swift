import Foundation

public extension FileManager {
    func createDirectory(at url: URL,
                         attributes: [FileAttributeKey : Any]? = nil,
                         force: Bool) throws {
        if force && fileExists(atPath: url.path) {
            try removeItem(at: url)
        }
        try createDirectory(at: url,
                            withIntermediateDirectories: true,
                            attributes: attributes)
    }
    
    func removeContentsOfDirectory(atPath path: String) throws {
        let contents = try contentsOfDirectory(atPath: path)
        for content in contents {
            let contentURL = URL(fileURLWithPath: path).appendingPathComponent(content)
            try removeItem(at: contentURL)
        }
    }
}

public extension FileManager {

    func sizeOfItem(atPath path: String) throws -> UInt64 {
        var size: UInt64 = 0
        var isDirectory = ObjCBool(false)
        assert(fileExists(atPath: path, isDirectory: &isDirectory), "Item at path: \(path) doesn't exist")
        size += try fileSize(atPath: path)
        
        if isDirectory.boolValue {
            let subpaths = try subpathsOfDirectory(atPath: path)
            for subpath in subpaths {
                size += try fileSize(atPath: path.appending("/\(subpath)"))
            }
        }
        return size
    }
    
    func sizeOfItems(atPaths paths: [String]) throws -> UInt64 {
        var size: UInt64 = 0
        for path in paths {
            size += try FileManager.default.sizeOfItem(atPath: path)
        }
        return size
    }
    
    func sizeOfItem(at srcURL: URL) throws -> UInt64 {
        return try sizeOfItem(atPath: srcURL.path)
    }

    func sizeOfItems(at srcURLs: [URL]) throws -> UInt64 {
        return try sizeOfItems(atPaths: srcURLs.compactMap { $0.path } )
    }
}

private extension FileManager {
    func fileSize(atPath path: String) throws -> UInt64 {
        let attributes = try attributesOfItem(atPath: path)
        return (attributes[FileAttributeKey.size] as! NSNumber).uint64Value
    }
}
