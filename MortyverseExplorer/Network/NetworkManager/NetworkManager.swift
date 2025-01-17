//
//  NetworkManager.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/05/2024.
//

import Foundation
import Combine

/// Protocol defining functionalities for sending network requests.
public protocol NetworkSendableProtocol {
    /// Sends a network request using a completion handler.
    ///
    /// - Parameters:
    ///   - model: The Codable model to decode the response.
    ///   - endpoint: The endpoint to send the request to.
    ///   - completionHandler: The completion handler returning a Result type with either the decoded model or a NetworkError.
    func send<T: Codable>(
        model: T.Type,
        endpoint: BaseEndpoint,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    )
    
    /// Sends a network request using async/await.
    ///
    /// - Parameters:
    ///   - model: The Codable model to decode the response.
    ///   - endpoint: The endpoint to send the request to.
    /// - Returns: The decoded model.
    /// - Throws: A NetworkError if the request fails or the data cannot be parsed.
    func send<T: Codable>(
        model: T.Type,
        endpoint: BaseEndpoint
    ) async throws -> T
    
    /// Sends a network request using Combine publishers.
    ///
    /// - Parameters:
    ///   - model: The Codable model to decode the response.
    ///   - endPoint: The endpoint to send the request to.
    /// - Returns: A publisher that emits the decoded model or a NetworkError.
    func send<T: Codable>(
        model: T.Type,
        endPoint: BaseEndpoint
    ) -> AnyPublisher<T, NetworkError>
}

/// A class responsible for managing network requests.
public final class NetworkManager {
    /// The shared instance of NetworkManager.
    public static let shared = NetworkManager()
    
    private var networkService: NetworkServiceProtocol
    private var parser: NetworkParserProtocol
    
    /// Initializes a new instance of NetworkManager.
    ///
    /// - Parameters:
    ///   - networkService: The network service to be used for sending requests. Defaults to NetworkService().
    ///   - parser: The network response parser. Defaults to NetworkParser().
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        parser: NetworkParserProtocol = NetworkParser()
    ) {
        self.networkService = networkService
        self.parser = parser
    }
}

extension NetworkManager: NetworkSendableProtocol {
    /// Sends a network request using a completion handler.
    ///
    /// - Parameters:
    ///   - model: The Codable model to decode the response.
    ///   - endpoint: The endpoint to send the request to.
    ///   - completionHandler: The completion handler returning a Result type with either the decoded model or a NetworkError.
    public func send<T: Codable>(
        model: T.Type,
        endpoint: BaseEndpoint,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        networkService.sendRequest(to: endpoint) { [weak self] data, response, error in
            guard let self = self else {
                completionHandler(.failure(.connectionFailed))
                return
            }
            let result = self.parser.handleNetworkResponse(
                model: model,
                data: data,
                response: response,
                error: error
            )
            completionHandler(result)
        }
    }
    
    /// Sends a network request using async/await.
    ///
    /// - Parameters:
    ///   - model: The Codable model to decode the response.
    ///   - endpoint: The endpoint to send the request to.
    /// - Returns: The decoded model.
    /// - Throws: A NetworkError if the request fails or the data cannot be parsed.
    public func send<T: Codable>(
        model: T.Type,
        endpoint: BaseEndpoint
    ) async throws -> T {
        do {
            let (data, response) = try await networkService.sendRequest(to: endpoint)
            return try await parser.handleNetworkResponse(
                model: model,
                data: data,
                response: response,
                error: nil
            )
        } catch {
            return try await parser.handleNetworkResponse(
                model: model,
                data: nil,
                response: nil,
                error: error
            )
        }
    }
    
    /// Sends a network request using Combine publishers.
    ///
    /// - Parameters:
    ///   - model: The Codable model to decode the response.
    ///   - endPoint: The endpoint to send the request to.
    /// - Returns: A publisher that emits the decoded model or a NetworkError.
    public func send<T: Codable>(
        model: T.Type,
        endPoint: BaseEndpoint
    ) -> AnyPublisher<T, NetworkError> {
        return networkService.sendRequest(to: endPoint)
            .tryMap { [weak self] data, response -> T in
                guard let self = self else {
                    throw NetworkError.connectionFailed
                }
                // Use the parser to handle the network response
                let result = self.parser.handleNetworkResponse(model: model, data: data, response: response, error: nil)
                // Handle the result, return the parsed model or throw the corresponding error
                switch result {
                case .success(let decodedModel):
                    return decodedModel
                case .failure(let networkError):
                    throw networkError
                }
            }
            .mapError { error -> NetworkError in
                // Try to cast the error to NetworkError, or default to `.connectionFailed`
                return error as? NetworkError ?? .connectionFailed
            }
            .eraseToAnyPublisher()
    }
}
