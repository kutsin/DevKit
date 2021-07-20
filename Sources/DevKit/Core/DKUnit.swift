import Foundation

public struct DKUnit {
    
    public let bytes: UInt64
    
    public init(bytes: UInt64) {
        self.bytes = bytes
    }
    
    public var kilobytes: Double {
        return Double(bytes) / 1024
    }
    
    public var megabytes: Double {
        return kilobytes / 1024
    }
    
    public var gigabytes: Double {
        return megabytes / 1024
    }
    
    public var localizedDesciption: String {
        switch bytes {
        case 1024 ..< (1024 * 1024): return "\(String(format: "%.2f", kilobytes)) KB"
        case 1024 ..< (1024 * 1024 * 1024): return "\(String(format: "%.2f", megabytes)) MB"
        case (1024 * 1024 * 1024) ... UInt64.max: return "\(String(format: "%.2f", gigabytes)) GB"
        default: return "\(bytes) bytes"
        }
    }
}
