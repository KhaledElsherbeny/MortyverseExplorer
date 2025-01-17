//
//  LoaderView.swift
//  MortyverseExplorer
//
//  Created by Khalid on 20/10/2024.
//

import UIKit
import SwiftUI

public class LoadingView {
    private static var hostingController: UIHostingController<LoaderView>?
    
    public static func show() {
        DispatchQueue.main.async {
            // Create the loader view
            let loaderView = LoaderView()
            let hostingController = UIHostingController(rootView: loaderView)
            
            // Set the static hosting controller
            self.hostingController = hostingController
            
            // Get the main window
            if let window = UIApplication.shared.activeWindow {
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                window.addSubview(hostingController.view)
                
                // Constraints to fill the parent view
                NSLayoutConstraint.activate([
                    hostingController.view.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                    hostingController.view.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                    hostingController.view.topAnchor.constraint(equalTo: window.topAnchor),
                    hostingController.view.bottomAnchor.constraint(equalTo: window.bottomAnchor)
                ])
            }
        }
    }
    
    public static func hide() {
        DispatchQueue.main.async {
            // Remove the loader view if it's being displayed
            if let hostingController = hostingController {
                hostingController.view.removeFromSuperview()
                self.hostingController = nil
            }
        }
    }
}

private struct LoaderView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2) // Semi-transparent background
                .edgesIgnoringSafeArea(.all) // Cover the entire screen
            
            ProgressView() // This is the spinner
                .progressViewStyle(CircularProgressViewStyle(tint: .white)) // Customize the spinner
                .scaleEffect(2) // Adjust size if needed
        }
    }
}
