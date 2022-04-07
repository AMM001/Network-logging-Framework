//
//  SessionManager.swift
//  InstabugInterview
//
//  Created by admin on 07/04/2022.
//

class SessionManager {

    var session: URLSession?
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 30
        sessionConfiguration.waitsForConnectivity = true
        session = URLSession(configuration: sessionConfiguration)
    }
    
    
    deinit {
        session?.invalidateAndCancel()
        session = nil
    }
    
}
