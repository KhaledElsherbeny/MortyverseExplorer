//
//  DriverPerformanceService.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/09/2024.
//

import Combine

protocol CharactersServiceProtocol {
    func fetchCharacters(at page: Int) -> AnyPublisher<CharacterListDTO, NetworkError>
}

final class CharactersService: CharactersServiceProtocol {
    
    var networkManager: NetworkSendableProtocol = NetworkManager.shared
    
    func fetchCharacters(at page: Int) -> AnyPublisher<CharacterListDTO, NetworkError> {
        let endpoint = CharactersEndpoint.getCharacters(page: page)
        return networkManager.send(model: CharacterListDTO.self, endPoint: endpoint)
    }
}
