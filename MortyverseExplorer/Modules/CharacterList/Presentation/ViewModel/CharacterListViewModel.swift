//
//  CharacterListViewModel.swift
//  MortyverseExplorer
//
//  Created by Khalid on 20/10/2024.
//

import Foundation
import Combine

// MARK: - State Enum
enum CharacterListState: Equatable {
    case idle
    case loading
    case error(String)
}

// MARK: - View Model Implementation
final class CharacterListViewModel: ObservableObject {
    // MARK: - Published Properties
    private var characters: [CharacterListItem] = []
    @Published private(set) var filteredCharacters: [CharacterListItem] = []
    @Published private(set) var state: CharacterListState = .idle
    @Published private(set) var filters: [CharacterFilterItem]
    
    // MARK: - Private Properties
    private let useCase: CharacterListUsecaseProtocol
    private let coordinator: CharacterListCoordinatorProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        useCase: CharacterListUsecaseProtocol,
        coordinator: CharacterListCoordinatorProtocol
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.filters = CharacterFilterItem.defaultFilters()
        self.filteredCharacters = characters  // Initialize filtered characters with all characters
    }
    
    // MARK: - Public Methods
    func fetchCharacters() {
        if case .loading = state { return }
        
        state = .loading
        
        useCase.fetchCharacters()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in self?.handleCompletion($0) },
                receiveValue: { [weak self] in self?.handleNewCharacters($0) }
            )
            .store(in: &cancellables)
    }
    
    func fetchMoreCharactersIfNeeded() {
        guard useCase.hasMoreCharacters else { return }
        fetchCharacters()
    }
    
    func resetPagination() {
        useCase.resetPagination()
        characters.removeAll()
        fetchCharacters()
    }
    
    func applyFilter(_ filter: CharacterFilterItem, at index: Int) {
        // Update the filter at the specified index
        filters[index] = filter
        
        if filter.isSelected {
            // If the filter is selected, apply it
            filteredCharacters = characters.filter { $0.status == filter.status }
            
            // Deselect other filters
            for i in filters.indices where i != index {
                filters[i].isSelected = false
            }
        } else {
            // If the filter is deselected, show all characters
            filteredCharacters = characters
        }
    }
    
    // MARK: - Private Methods
    private func handleCompletion(_ completion: Subscribers.Completion<NetworkError>) {
        switch completion {
        case .finished:
            state = .idle
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }
    
    private func handleNewCharacters(_ newCharacters: [CharacterListItem]) {
        characters.append(contentsOf: newCharacters)
        updateFilteredCharacters()
    }
    
    private func updateFilteredCharacters() {
        // Check if there's any selected filter
        if let activeFilter = filters.first(where: { $0.isSelected }) {
            filteredCharacters = characters.filter { $0.status == activeFilter.status }
        } else {
            // If no filter is selected, show all characters
            filteredCharacters = characters
        }
    }
}

extension CharacterListViewModel {
    func didSelectCharacter(_ index: Int) {
        let character = filteredCharacters[index]
        coordinator.showCharacterDetails(character: character)
    }
}
