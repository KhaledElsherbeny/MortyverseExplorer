//
//  CharacterFilterView.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit

protocol CharacterFilterViewDelegate {
    func didPressFilter(filter: CharacterFilterItem, at index: IndexPath)
}

final class CharacterFilterView: UIView {
    
    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    var filters: [CharacterFilterItem] = []
    var delegate: CharacterFilterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            CharacterFilterItemCell.nib,
            forCellWithReuseIdentifier: CharacterFilterItemCell.viewIdentifier
        )
    }
    
    func setup(filters: [CharacterFilterItem], delegate: CharacterFilterViewDelegate?) {
        self.filters = filters
        self.delegate = delegate
        self.collectionView.reloadData()
    }
}

extension CharacterFilterView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = CharacterFilterItemCell.instance(collectionView, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let filterItem = filters[indexPath.row]
        cell.setup(with: CharacterFilterItemCellViewModel(filterItem: filterItem))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterItem = filters[indexPath.row]

        // Check if the tapped item is already selected
        if filterItem.isSelected {
            // Deselect the item
            filters[indexPath.row].isSelected = false
            collectionView.reloadItems(at: [indexPath])
        } else {
            // Unselect previously selected item, if any
            if let selectedIndex = filters.firstIndex(where: { $0.isSelected }) {
                filters[selectedIndex].isSelected = false
                collectionView.reloadItems(at: [IndexPath(item: selectedIndex, section: indexPath.section)])
            }

            // Select the new item
            filters[indexPath.row].isSelected = true
            collectionView.reloadItems(at: [indexPath])
        }
        
        // Notify delegate
        delegate?.didPressFilter(filter: filters[indexPath.row], at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = filters[indexPath.item]
        
        // Calculate the size based on the content
        let padding: CGFloat = 40 // Add padding for the cell
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold) // Use your desired font
        let size = (filter.status.rawValue as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        
        return CGSize(width: size.width + padding, height: collectionView.bounds.height)
    }
}
