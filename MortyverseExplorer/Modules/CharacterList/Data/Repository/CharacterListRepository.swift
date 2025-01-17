//
//  DriverPerformanceRepository.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/09/2024.
//

import Foundation
import Combine

final class CharacterListRepository: CharacterListRepositoryProtocol {
    var charactersService: CharactersServiceProtocol
    
    init(charactersService: CharactersServiceProtocol) {
        self.charactersService = charactersService
    }
    
    func fetchCharacters(at page: Int) -> AnyPublisher<CharacterList, NetworkError> {
        return charactersService.fetchCharacters(at: page)
            .tryMap { response in
                return CharacterList(response: response)
            }
            .mapError { error in
                // Convert any Error to NetworkError
                error as? NetworkError ?? .connectionFailed
            }
            .eraseToAnyPublisher()
    }
}
