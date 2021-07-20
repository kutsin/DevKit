import Foundation

public extension Bundle {
    var versionNumber: String {
        return infoDictionary!["CFBundleShortVersionString"] as! String
    }
    var buildNumber: String {
        return infoDictionary!["CFBundleVersion"] as! String
    }
}
