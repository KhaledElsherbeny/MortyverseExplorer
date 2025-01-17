//
//  DriverPerformanceUsecase.swift
//  MortyverseExplorer
//
//  Created by Khalid on 03/09/2024.
//

import Foundation
import Combine

protocol CharacterListUsecaseProtocol {
    var hasMoreCharacters: Bool { get }

    func fetchCharacters() -> AnyPublisher<[CharacterListItem], NetworkError>
    func resetPagination()
}

class CharacterListUsecase: CharacterListUsecaseProtocol {
    private let characterListRepository: CharacterListRepositoryProtocol
        
    private var currentPage = 1
    private var totalPages = 0
    private var isFetching = false

    var hasMoreCharacters: Bool {
        currentPage < totalPages
    }
    
    init(characterListRepository: CharacterListRepositoryProtocol) {
        self.characterListRepository = characterListRepository
    }
    
    func fetchCharacters() -> AnyPublisher<[CharacterListItem], NetworkError> {
        // Check if there's an ongoing fetch or if we've already fetched all pages
        guard !isFetching, currentPage <= totalPages || totalPages == 0 else {
            // Instead of returning an error, return an empty array
            return Just([])
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        isFetching = true
        
        // Fetch characters from the repository
        return characterListRepository.fetchCharacters(at: currentPage)
            .handleEvents(receiveOutput: { [weak self] characterList in
                self?.totalPages = characterList.pagingInfo?.pages ?? 0
                self?.currentPage += 1
            }, receiveCompletion: { [weak self] _ in
                self?.isFetching = false
            })
            .map { $0.characters ?? [] } // Extract the characters array from the response
            .eraseToAnyPublisher()
    }

    func resetPagination() {
        currentPage = 1
        totalPages = 0
        isFetching = false
    }
}
