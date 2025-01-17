//
//  Coordinator.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
