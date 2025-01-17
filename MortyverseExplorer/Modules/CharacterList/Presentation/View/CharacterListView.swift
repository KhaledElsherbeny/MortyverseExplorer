//
//  ViewController.swift
//  MortyverseExplorer
//
//  Created by Khalid on 13/10/2024.
//

import UIKit
import Combine

final class CharacterListView: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private(set) var tableView: UITableView!
    @IBOutlet weak private(set) var filterContainerView: CharacterFilterView!
    
    // MARK: - Properties
    var viewModel: CharacterListViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: CharacterListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationTitle()
        setupFilterView()
        bindViewModel()
        viewModel.fetchCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Setup Methods
    private func setupNavigationTitle() {
        navigationItem.title = "Characters"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupFilterView() {
        filterContainerView.setup(filters: viewModel?.filters ?? [], delegate: self)
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        // Bind filtered characters array to update the table view
        viewModel.$filteredCharacters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Bind state changes
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func handleStateChange(_ state: CharacterListState) {
        switch state {
        case .idle:
            LoadingView.hide()
        case .loading:
            LoadingView.show()
        case .error(let message):
            LoadingView.hide()
            showErrorMessage(message: message)
        }
    }
    
    private func showErrorMessage(message: String) {
        let alertController = AlertBuilder(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
            .addAction(title: "Ok", style: .default, handler: nil)
            .build()
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CharacterFilterViewDelegate Extension
extension CharacterListView: CharacterFilterViewDelegate {
    func didPressFilter(filter: CharacterFilterItem, at index: IndexPath) {
        viewModel.applyFilter(filter, at: index.row)
    }
}
