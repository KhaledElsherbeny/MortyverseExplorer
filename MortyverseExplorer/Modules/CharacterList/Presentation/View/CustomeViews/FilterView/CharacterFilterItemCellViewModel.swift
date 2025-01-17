//
//  CharacterFilterItemCellViewModel.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit

struct CharacterFilterItemCellViewModel {
    var title: String
    var backroundColor: UIColor
}

extension CharacterFilterItemCellViewModel {
    init(filterItem: CharacterFilterItem) {
        self.title = filterItem.status.rawValue
        self.backroundColor = filterItem.isSelected ? .secondarySystemBackground : .white
    }
}
