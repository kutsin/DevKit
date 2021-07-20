import Foundation

public extension FileHandle {
    
    private struct Error: Swift.Error, LocalizedError {
        
        static let notFound = Error(message: "Data not found")

        var message: String
        
        var errorDescription: String? {
            return message
        }
    }
    
    enum SeekDirection {
        case forward, backward
    }
    
    func seek(toKeyword keyword: String, direction: SeekDirection = .forward) throws -> Bool {
        let keywordData = keyword.data(using: .utf8)!
        return try seek(toData: keywordData, direction: direction)
    }
    
    func seek(toData data: Data, direction: SeekDirection = .forward) throws -> Bool {
        try seekToEnd_()
        let endOffset = offsetInFile
        if direction == .backward {
            let fromOffset: UInt64 = offsetInFile < 1024 ? 0 : offsetInFile - 1024
            return try seek(toData: data, direction: direction, fromOffset: fromOffset, endOffset: endOffset)
        } else {
            try seek_(toOffset: 0)
            return try seek(toData: data, direction: direction, fromOffset: 0, endOffset: endOffset)
        }
    }
    
    func seek(toData data: Data, direction: SeekDirection, fromOffset: UInt64, endOffset: UInt64) throws -> Bool {
        if fromOffset >= endOffset {
            return false
        }
        var length: UInt64 = 1024
        if endOffset - fromOffset < 1024 {
            length = endOffset - fromOffset
        }
        try seek_(toOffset: fromOffset)
        
        let currentData = readData(ofLength: Int(length))
        if let range = currentData.range(of: data) {
            try seek_(toOffset: offsetInFile - length + UInt64(range.startIndex))
            return true
        } else {
            let nextOffset: UInt64
            if direction == .forward {
                nextOffset = offsetInFile - UInt64(data.count)
            } else {
                if offsetInFile == length {
                    return false
                }
                if offsetInFile < length * 2 + UInt64(data.count) {
                    nextOffset = 0
                } else {
                    nextOffset = offsetInFile - length * 2 - UInt64(data.count)
                }
            }
            return try seek(toData: data, direction: direction, fromOffset: nextOffset, endOffset: endOffset)
        }
    }
    
    func findData(fromKeyword keyword: String) throws -> Data? {
        let found = try seek(toKeyword: keyword, direction: .backward)
        if found {
            let keywordData = keyword.data(using: .utf8)!
            try seek_(toOffset: offsetInFile + UInt64(keywordData.count))
            let data = try readToEnd_()
            return data
        }
        return nil
    }
    
    func truncatedData(fromKeyword keyword: String) throws -> Data? {
        let found = try seek(toKeyword: keyword, direction: .backward)
        if found {
            let fromOffset = offsetInFile
            let keywordData = keyword.data(using: .utf8)!
            try seek_(toOffset: offsetInFile + UInt64(keywordData.count))
            let data = try readToEnd_()
            try truncate_(atOffset: fromOffset)
            return data
        }
        return nil
    }
    
    func seekToEnd_() throws {
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            try seekToEnd()
        } else {
            seekToEndOfFile()
        }
    }
    
    func seek_(toOffset offset: UInt64) throws {
        if #available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            try seek(toOffset: offset)
        } else {
            seek(toFileOffset: offset)
        }
    }
    
    func readToEnd_() throws -> Data? {
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            return try readToEnd()
        } else {
            return readDataToEndOfFile()
        }
    }
    
    func truncate_(atOffset offset: UInt64) throws {
        if #available(OSX 10.15.4, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            try truncate(atOffset: offset)
        } else {
            truncateFile(atOffset: offset)
        }
    }
    
    func close_() throws {
        if #available(OSX 10.15.4, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            try close()
        } else {
            closeFile()
        }
    }
    
    func write_<T>(contentsOf data: T) throws where T : DataProtocol {
        if #available(OSX 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            try write(contentsOf: data)
        } else {
            write(Data(data))
        }
    }
}
