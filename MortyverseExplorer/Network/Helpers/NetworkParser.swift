//
//  NetworkParser.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/05/2024.
//

import Foundation

/// Protocol defining functionalities for parsing network responses.
protocol NetworkParserProtocol {
    func handleNetworkResponse<T: Codable>(
        model: T.Type,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Result<T, NetworkError>
    
    func handleNetworkResponse<T: Codable>(
        model: T.Type,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) async throws -> T
}

/// Class responsible for parsing network responses.
final class NetworkParser: NetworkParserProtocol {
    
    /// Handles the network response based on the provided model.
    ///
    /// - Parameters:
    ///   - model: The model type to decode the response.
    ///   - data: The response data.
    ///   - response: The URL response.
    ///   - error: The error, if any.
    /// - Returns: A Result object with the decoded model or a NetworkError.
    func handleNetworkResponse<T: Codable>(
        model: T.Type,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Result<T, NetworkError> {
        do {
            let model = try handleResponse(model: model, data: data, response: response, error: error)
            return .success(model)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.connectionFailed)
        }
    }
    
    /// Handles the network response asynchronously based on the provided model.
    ///
    /// - Parameters:
    ///   - model: The model type to decode the response.
    ///   - data: The response data.
    ///   - response: The URL response.
    ///   - error: The error, if any.
    /// - Returns: The decoded model.
    /// - Throws: A NetworkError if the request fails or the data cannot be parsed.
    func handleNetworkResponse<T: Codable>(
        model: T.Type,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) async throws -> T {
        try handleResponse(model: model, data: data, response: response, error: error)
    }

    /// Common method to handle the network response and parse the data.
    ///
    /// - Parameters:
    ///   - model: The model type to decode the response.
    ///   - data: The response data.
    ///   - response: The URL response.
    ///   - error: The error, if any.
    /// - Returns: The decoded model.
    /// - Throws: A NetworkError if the request fails or the data cannot be parsed.
    private func handleResponse<T: Codable>(
        model: T.Type,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) throws -> T {
        if let _ = error {
            throw NetworkError.connectionFailed
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.connectionFailed
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try parseData(model: model, data: data)
        case 401:
            throw NetworkError.authenticationError
        case 400...499:
            throw NetworkError.badRequest
        case 500...599:
            throw NetworkError.serverError
        case 600:
            throw NetworkError.outdated
        default:
            throw NetworkError.connectionFailed
        }
    }

    /// Parses the response data to the provided model type.
    ///
    /// - Parameters:
    ///   - model: The model type to decode the response.
    ///   - data: The response data.
    /// - Returns: The decoded model.
    /// - Throws: A NetworkError if the data cannot be parsed.
    private func parseData<T: Codable>(
        model: T.Type,
        data: Data?
    ) throws -> T {
        guard let data = data else {
            throw NetworkError.noData
        }
        
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch {
            throw NetworkError.unableToDecode
        }
    }
}

