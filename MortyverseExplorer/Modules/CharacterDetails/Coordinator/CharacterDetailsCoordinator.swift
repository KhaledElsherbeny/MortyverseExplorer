//
//  CharacterDetailsCoordinator.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit

protocol CharacterDetailsCoordinatorProtocol {
    func dismissCharacterDetails()
}

final class CharacterDetailsCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let character: CharacterListItem
    
    init(navigationController: UINavigationController, character: CharacterListItem) {
        self.navigationController = navigationController
        self.character = character
    }
    
    func start() {
        let viewModel = CharacterDetailsViewModel(character: character, coordinator: self)
        let characterDetailsVC = CharacterDetailsView(viewModel: viewModel)
        navigationController.pushViewController(characterDetailsVC, animated: true)
    }
}

extension CharacterDetailsCoordinator: CharacterDetailsCoordinatorProtocol {
    func dismissCharacterDetails() {
        navigationController.popViewController(animated: true)
    }
}
