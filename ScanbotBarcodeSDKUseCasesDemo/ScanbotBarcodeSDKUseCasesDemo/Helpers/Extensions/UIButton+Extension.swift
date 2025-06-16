//
//  UIButton+Extension.swift
//  ScanbotBarcodeSDKUseCasesDemo
//
//  Created by Rana Sohaib on 21.07.23.
//

import UIKit

extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
