//
//  NetworkLogger.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/05/2024.
//

import Foundation

/// Utility class for logging network requests and responses.
class NetworkLogger {
    /// Logs a network request.
    ///
    /// - Parameter request: The network request to be logged.
    static func log(request: URLRequest) {
        print("Request: \(request)")
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody {
            print("Body: \(String(decoding: body, as: UTF8.self))")
        }
    }
    
    /// Logs a network response and its data.
    ///
    /// - Parameters:
    ///   - response: The network response to be logged.
    ///   - data: The data received from the network response.
    static func log(response: URLResponse?, data: Data?) {
        if let httpResponse = response as? HTTPURLResponse {
            print("Response: \(httpResponse)")
            if let headers = httpResponse.allHeaderFields as? [String: Any] {
                print("Headers: \(headers)")
            }
        }
        if let data = data, let responseBody = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseBody)")
        }
    }
    
    /// Logs an error that occurred during a network request.
    ///
    /// - Parameter error: The error to be logged.
    static func log(error: Error) {
        print("Error: \(error)")
    }
}
