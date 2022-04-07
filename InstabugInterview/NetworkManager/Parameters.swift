//
//  Parameters.swift
//  InstabugInterview
//
//  Created by admin on 07/04/2022.
//

import Foundation

public typealias Parameters = [String : Any]
public typealias HTTPHeaders = [String: String]

public enum OperationResult {
    // reponse.
    case result(_ : Data?, _ : HTTPURLResponse?)
    // An error.
    case error(_ : APIError?, _ : HTTPURLResponse?)
}


@propertyWrapper
public struct CustomPayload {
    
    private var value: [String: Any]?

    public init(wrappedValue: [String: Any]?) {
        self.value = wrappedValue
    }
    
    public var projectedValue: Data? {
       get { convertToData() }
     }
    
    public var wrappedValue: [String: Any]? {
        set {
            value = newValue
        }
        get { value }
    }
    
    private func convertToData() -> Data? {
        guard let value = value else {
            return nil
        }
        let bodyParametersData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
        return bodyParametersData?.validate()
    }
}
