//
//  CharacterFilterItemCell.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit

final class CharacterFilterItemCell: UICollectionViewCell {
    
    @IBOutlet weak private(set) var containerView: UIView!
    @IBOutlet weak private(set) var filterTitleLabel: UILabel!
    
    func setup(with viewModel: CharacterFilterItemCellViewModel) {
        filterTitleLabel.text = viewModel.title
        containerView.backgroundColor = viewModel.backroundColor
        
    }
}
