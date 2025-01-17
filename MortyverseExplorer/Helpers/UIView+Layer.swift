//
//  UIView+Layer.swift
//  MortyverseExplorer
//
//  Created by Khalid on 20/10/2024.
//

import UIKit

// @IBDesignable
extension UIView {
    
    // MARK: - Border Properties
    @IBInspectable open var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable open var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    // MARK: - Corner Radius
    @IBInspectable open var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    // MARK: - Opacity
    @IBInspectable open var opacity: Float {
        get { layer.opacity }
        set { layer.opacity = newValue }
    }
    
    // MARK: - Shadow Properties
    @IBInspectable open var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }

    @IBInspectable open var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable open var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable open var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable open var shadowPath: CGPath? {
        get { layer.shadowPath }
        set { layer.shadowPath = newValue }
    }
}
