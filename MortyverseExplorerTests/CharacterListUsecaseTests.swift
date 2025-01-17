//
//  CharacterListUsecaseTests.swift
//  MortyverseExplorerTests
//
//  Created by Khalid on 21/10/2024.
//

import XCTest
import Combine
@testable import MortyverseExplorer

class CharacterListUsecaseTests: XCTestCase {
    private var usecase: CharacterListUsecase!
    private var mockRepository: MockCharacterListRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockCharacterListRepository()
        usecase = CharacterListUsecase(characterListRepository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        cancellables = []
        super.tearDown()
    }

    func testFetchCharactersSuccess() {
        // Given
        let characterList = [CharacterListItem(id: 1, name: "Character 1"), CharacterListItem(id: 2, name: "Character 2")]
        let response = CharacterList(pagingInfo: CharacterListPageInfo(count: 100, pages: 25), characters: characterList)
        mockRepository.fetchCharactersResult = .success(response)
        
        // When
        let expectation = XCTestExpectation(description: "Fetch Characters")
        usecase.fetchCharacters()
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                // Then
                XCTAssertEqual(result.count, 2)
                XCTAssertEqual(result[0].name, "Character 1")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchCharactersNoMorePages() {
        // Given
        usecase.resetPagination()
        let response = CharacterList(pagingInfo: CharacterListPageInfo(count: 100, pages: 1), characters: [])
        mockRepository.fetchCharactersResult = .success(response)

        // Fetch first page
        usecase.fetchCharacters()
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        // When all pages are fetched, hasMoreCharacters should return false
        XCTAssertFalse(usecase.hasMoreCharacters)
    }
}

class MockCharacterListRepository: CharacterListRepositoryProtocol {
    var fetchCharactersResult: Result<CharacterList, NetworkError>?
    
    func fetchCharacters(at page: Int) -> AnyPublisher<CharacterList, NetworkError> {
        if let result = fetchCharactersResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.connectionFailed)
            .eraseToAnyPublisher()
    }
}
