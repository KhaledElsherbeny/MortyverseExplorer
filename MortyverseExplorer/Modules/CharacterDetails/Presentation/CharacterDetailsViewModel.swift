//
//  CharacterDetailsViewModel.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import Combine

final class CharacterDetailsViewModel: ObservableObject {
    private(set) var character: CharacterListItem
    private let coordinator: CharacterDetailsCoordinatorProtocol
    
    init(
        character: CharacterListItem,
        coordinator: CharacterDetailsCoordinatorProtocol
    ) {
        self.character = character
        self.coordinator = coordinator
    }
    
    func closeDetails() {
        coordinator.dismissCharacterDetails()
    }
}

