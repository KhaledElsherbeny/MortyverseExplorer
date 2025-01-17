//
//  CharacterDetailsView.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit
import Combine

final class CharacterDetailsView: UIViewController {
    
    @IBOutlet weak private(set) var characterImageView: UIImageView!
    @IBOutlet weak private(set) var characterNameLabel: UILabel!
    @IBOutlet weak private(set) var characterSpeciesLabel: UILabel!
    @IBOutlet weak private(set) var characterStatusLabel: UILabel!
    @IBOutlet weak private(set) var characterGenderLabel: UILabel!
    @IBOutlet weak private(set) var characterLocationLabel: UILabel!
    
    var imageDownloader: ImageDownloadable = ImageDownloader.shared

    private var viewModel: CharacterDetailsViewModel
    private var cancellables = Set<AnyCancellable>()

    private struct Constants {
        static let placeholderImageName = "placeholder-img"
    }

    // MARK: - Initialization
    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        displayCharacterDetails()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
        
    private func displayCharacterDetails() {
        characterNameLabel.text = viewModel.character.name
        characterSpeciesLabel.text = viewModel.character.species
        characterStatusLabel.text = viewModel.character.status?.rawValue
        characterGenderLabel.text = viewModel.character.gender
        characterLocationLabel.text = viewModel.character.location?.name
        
        if let image = viewModel.character.image, let imageURL = URL(string: image) {
            downloadImage(url: imageURL)
        } else {
            setIconPlaceHolderImage()
        }
    }
    
    private func downloadImage(url: URL) {
        imageDownloader.fetchImage(from: url) { [weak self] response in
            switch response {
            case .success(let image):
                self?.characterImageView.image = image
            case .failure:
                self?.setIconPlaceHolderImage()
            }
        }
    }
    
    private func setIconPlaceHolderImage() {
        characterImageView.image = UIImage(named: Constants.placeholderImageName)
    }

    @IBAction private func backAction(_ sender: Any) {
        viewModel.closeDetails()
    }
}
