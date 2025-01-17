//
//  NetworkError.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/05/2024.
//

import Foundation

/// Enum defining network error cases.
public enum NetworkError: Error {
    /// Authentication error.
    case authenticationError
    /// Bad request error.
    case badRequest
    /// Outdated URL error.
    case outdated
    /// Connection failed error.
    case connectionFailed
    /// No data error.
    case noData
    /// Unable to decode response error.
    case unableToDecode
    /// Server error.
    case serverError
    /// Timeout error.
    case timeout
    /// Invalid response error (e.g., non-200 HTTP codes).
    case invalidResponse
}

extension NetworkError: LocalizedError {
    /// Localized description of network error.
    public var errorDescription: String? {
        switch self {
        case .authenticationError:
            return NSLocalizedString("You need to be authenticated first.", comment: "")
        case .badRequest:
            return NSLocalizedString("Bad request.", comment: "")
        case .outdated:
            return NSLocalizedString("The requested URL is outdated.", comment: "")
        case .connectionFailed:
            return NSLocalizedString("Network request failed.", comment: "")
        case .noData:
            return NSLocalizedString("Response returned with no data to decode.", comment: "")
        case .unableToDecode:
            return NSLocalizedString("Unable to decode the response.", comment: "")
        case .serverError:
            return NSLocalizedString("Server error.", comment: "")
        case .timeout:
            return NSLocalizedString("The request timed out.", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Invalid response received from the server.", comment: "")
        }
    }
}
