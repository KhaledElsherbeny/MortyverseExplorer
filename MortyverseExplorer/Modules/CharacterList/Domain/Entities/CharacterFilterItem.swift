//
//  CharacterFilterItem.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import Foundation

struct CharacterFilterItem {
    var status: Status
    var isSelected: Bool = false
}

// MARK: - Filter Item Extension
extension CharacterFilterItem {
    static func defaultFilters() -> [CharacterFilterItem] {
        [
            CharacterFilterItem(status: .dead),
            CharacterFilterItem(status: .alive),
            CharacterFilterItem(status: .unknown)
        ]
    }
}
