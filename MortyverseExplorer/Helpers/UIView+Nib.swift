//
//  UIView+Nib.swift
//  MortyverseExplorer
//
//  Created by Khalid on 21/10/2024.
//

import UIKit

extension UIView {

    /// Sets up the view by loading it from a nib file and adding it as a subview.
    /// It automatically resizes the loaded view to match the current bounds of the view.
    @objc func xibSetup() {
        guard let contentView = loadNibContentView() else {
            assertionFailure("Failed to load the view from nib: \(String(describing: type(of: self)))")
            return
        }
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }

    /// Loads the content view from a nib file matching the view's class name.
    /// - Returns: The loaded view or nil if it fails to load.
    private func loadNibContentView() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        
        guard let nib = UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: self, options: nil).first as? UIView else {
            return nil
        }
        
        return nib
    }

    /// Calculates the bottom Y-position relative to another view.
    /// - Parameter view: The view to calculate the relative position to.
    /// - Returns: The bottom Y-position relative to the given view.
    func bottomRelative(to view: UIView?) -> CGFloat {
        guard let referenceView = view else { return 0 }
        
        let globalOrigin = superview?.convert(frame, to: referenceView).origin.y ?? 0
        return globalOrigin + bounds.height
    }
}
