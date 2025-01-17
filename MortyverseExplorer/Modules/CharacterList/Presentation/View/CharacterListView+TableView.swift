//
//  CharacterListView+TableView.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit

extension CharacterListView {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CharacterItemTableViewCell.nib,
            forCellReuseIdentifier: CharacterItemTableViewCell.viewIdentifier
        )
    }
}

// MARK: - UITableViewDataSource

extension CharacterListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCharacters.count // Return the number of characters
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = CharacterItemTableViewCell.instance(tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        let character = viewModel.filteredCharacters[indexPath.row]
        cell.setup(with: character)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CharacterListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the user is reaching the last item
        if indexPath.row == viewModel.filteredCharacters.count - 1 {
            viewModel.fetchMoreCharactersIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCharacter(indexPath.row)
    }
}

