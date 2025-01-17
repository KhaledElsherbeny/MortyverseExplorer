//
//  AlertBuilder.swift
//  MortyverseExplorer
//
//  Created by Khalid on 20/10/2024.
//

import UIKit

final class AlertBuilder {
    private var alertController: UIAlertController

    init(title: String = "", message: String? = nil, preferredStyle: UIAlertController.Style = .alert) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }

    func addAction(action: UIAlertAction) -> Self {
        alertController.addAction(action)
        return self
    }

    func addAction(title: String = "", style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        alertController.addAction(action)
        return self
    }

    func build() -> UIAlertController {
        alertController
    }
}
