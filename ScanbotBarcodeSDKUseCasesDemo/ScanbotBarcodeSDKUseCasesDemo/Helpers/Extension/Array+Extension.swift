//
//  Array+Extension.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 14.07.23.
//

import Foundation
import ScanbotBarcodeScannerSDK

extension Array where Element == SBSDKBarcodeScannerResult {
    func contains(barcode: Element) -> Bool {
        return self.contains(where: {
            $0.rawTextStringWithExtension == barcode.rawTextStringWithExtension &&
            $0.type == barcode.type
        })
    }
}
