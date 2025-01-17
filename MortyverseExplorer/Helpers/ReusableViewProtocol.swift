//
//  ReusableViewProtocol.swift
//  MortyverseExplorer
//
//  Created by Khalid on 20/10/2024.
//

import UIKit

protocol CellInfo: AnyObject {
    static var viewIdentifier: String { get }
    static var nib: UINib { get }
}

/// Extend view with CellInfo , and get the view identifier with nib object
extension UIView: CellInfo {
    static var viewIdentifier: String {
        NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    static var nib: UINib {
        .init(nibName: viewIdentifier, bundle: nil)
    }
}

extension UICollectionViewCell {
    /// Create instance direct from collection view cell
    /// - Parameters:
    ///   - collection: UICollectionView
    ///   - indexPath: IndexPath
    /// - Returns: instance of generic collection view cell
    class func instance(_ collection: UICollectionView, indexPath: IndexPath) -> Self? {
        collection.dequeueReusableCell(withReuseIdentifier: viewIdentifier, for: indexPath) as? Self
    }
}

extension UITableViewCell {
    /// Create instance direct from table view cell
    /// - Parameters:
    ///   - tableView: UITableViewCell
    ///   - indexPath: IndexPath
    /// - Returns: instance of generic table view cell
    class func instance(_ tableView: UITableView, indexPath: IndexPath) -> Self? {
        tableView.dequeueReusableCell(withIdentifier: viewIdentifier, for: indexPath) as? Self
    }
}
