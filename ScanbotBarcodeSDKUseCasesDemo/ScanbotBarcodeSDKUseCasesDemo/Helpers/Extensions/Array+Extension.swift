//
//  Array+Extension.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 14.07.23.
//

import Foundation
import ScanbotBarcodeScannerSDK

extension Array where Element == SBSDKBarcodeItem {
    func contains(barcode: Element) -> Bool {
        return self.contains(where: {
            $0.textWithExtension == barcode.textWithExtension &&
            $0.format == barcode.format
        })
    }
}
