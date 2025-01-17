//
//  BaseEndpoint.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/05/2024.
//

import Foundation

/// Alias for request parameters.
public typealias Parameters = [String: Any]

/// Alias for request headers.
public typealias Headers = [String: String]

/// Enum defining different types of request encoding.
public enum RequestEncoding {
    case queryString
    case requestBody
    case multiPartFormData
}

/// Protocol defining the structure of a network endpoint.
public protocol BaseEndpoint {
    /// Base URL for the endpoint.
    var baseUrl: URL { get }
    /// Full URL for the request.
    var requestUrl: URL { get }
    /// Path for the request.
    var path: String { get }
    /// Parameters for the request.
    var parameters: Parameters { get }
    /// HTTP method for the request.
    var method: HTTPMethod { get }
    /// Headers for the request.
    var headers: Headers { get }
    /// Encoding type for the request.
    var encoding: RequestEncoding { get }
    /// URL request object.
    var urlRequest: URLRequest { get }
}

public extension BaseEndpoint {
    /// Default encoding type for the request.
    var encoding: RequestEncoding {
        switch method {
        default:
            return .queryString
        }
    }
    
    /// Base URL for the request.
    var baseUrl: URL {
        guard let url = URL(string: APIConstants.baseUrl) else {
            fatalError("Invalid Base URL, please check base URL.")
        }
        return url
    }
    
    /// HTTP method for the request.
    var method: HTTPMethod {
        return .get
    }
    
    /// Parameters for the request.
    var parameters: Parameters {
        return [:]
    }
    
    /// Headers for the request.
    var headers: Headers {
        return [:]
    }
    
    /// Full URL for the request.
    var requestUrl: URL {
        let strUrl = baseUrl.appendingPathComponent(path).absoluteString
        guard let url = URL(string: strUrl) else {
            fatalError("Invalid Endpoint URL, please check URL.")
        }
        return url
    }
    
    /// URLRequest object for the request.
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        
        request.httpBody = httpBody
        request.url = url
        request.allHTTPHeaderFields = allHTTPHeaders
                
        return request
    }
    
    /// HTTP body for the request.
    private var httpBody: Data? {
        guard encoding == .requestBody, !parameters.isEmpty else {
            return nil
        }
        guard let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            return nil
        }
        return bodyData
    }
    
    /// URL for the request.
    private var url: URL {
        guard encoding == .queryString,
              !parameters.isEmpty,
              var urlComponents = URLComponents(url: requestUrl, resolvingAgainstBaseURL: false) else {
            return requestUrl
        }
        
        urlComponents.queryItems = [URLQueryItem]()
        parameters.forEach {
            let queryItem = URLQueryItem(name: $0.key,value: "\($0.value)")
            urlComponents.queryItems?.append(queryItem)
        }
        return urlComponents.url ?? requestUrl
    }
    
    /// All HTTP headers for the request.
    private var allHTTPHeaders: [String: String] {
        var requestHeaders: [String: String] = headers
        switch encoding {
        case .multiPartFormData:
            requestHeaders["Content-Type"] = "multipart/form-data"
        case .requestBody,.queryString:
            requestHeaders["Content-Type"] = "application/json"
        }
        return requestHeaders
    }
}
