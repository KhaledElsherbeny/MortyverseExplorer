//
//  UIApplication+ActiveWindow.swift
//  MortyverseExplorer
//
//  Created by Khalid on 20/10/2024.
//

import UIKit

extension UIApplication {
    // Get the active window in iOS 15+ in a reusable way
    var activeWindow: UIWindow? {
        return connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
