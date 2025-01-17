//
//  CharacterItemTableViewCell.swift
//  MortyverseExplorer
//
//  Created by Khalid on 20/10/2024.
//

import UIKit

final class CharacterItemTableViewCell: UITableViewCell {

    @IBOutlet weak private(set) var characterImageView: UIImageView!
    @IBOutlet weak private(set) var characterNameLabel: UILabel!
    @IBOutlet weak private(set) var characterSpeciesLabel: UILabel!
    @IBOutlet weak private(set) var characterStatusLabel: UILabel!
    @IBOutlet weak private(set) var characterGenderLabel: UILabel!
    
    private struct Constants {
        static let placeholderImageName = "placeholder-img"
    }

    var imageDownloader: ImageDownloadable?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with character: CharacterListItem, imageDownloader: ImageDownloadable = ImageDownloader.shared) {
        self.imageDownloader = imageDownloader
        
        characterNameLabel.text = character.name
        characterSpeciesLabel.text = character.species
        characterStatusLabel.text = character.status?.rawValue
        characterGenderLabel.text = character.gender
        
        if let image = character.image, let imageURL = URL(string: image) {
            downloadImage(url: imageURL)
        } else {
            setIconPlaceHolderImage()
        }
    }
    
    private func downloadImage(url: URL) {
        imageDownloader?.fetchImage(from: url) { [weak self] response in
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
}
