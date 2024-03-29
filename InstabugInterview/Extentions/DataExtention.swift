//
//  DataExtention.swift
//  InstabugInterview
//
//  Created by admin on 07/04/2022.
//

import Foundation

extension Data {
    
    private func convertToMB() -> Double {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let sizeString = bcf.string(fromByteCount: Int64(self.count))
        guard let size = Double(sizeString.replacingOccurrences(of: " MB", with: "")) else { return 0}
        return size
    }
    
    //The payload body for request and response should not be larger than 1 MB.
    func validate() -> Data? {
        guard self.convertToMB() < 1 else { return Data("payload too large".utf8)}
        return self
    }
    
}
