//
//  CharacterListCoordinator.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit

protocol CharacterListCoordinatorProtocol {
    func showCharacterDetails(character: CharacterListItem)
}

final class CharacterListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = CharactersService()
        let repository = CharacterListRepository(charactersService: service)
        let useCase = CharacterListUsecase(characterListRepository: repository)
        let viewModel = CharacterListViewModel(useCase: useCase, coordinator: self)
        let characterListVC = CharacterListView(viewModel: viewModel)
        navigationController.pushViewController(characterListVC, animated: true)
    }
}

extension CharacterListCoordinator: CharacterListCoordinatorProtocol {
    func showCharacterDetails(character: CharacterListItem) {
        let detailsCoordinator = CharacterDetailsCoordinator(navigationController: navigationController, character: character)
        detailsCoordinator.start()
    }
}
