//
//  DetectBarcodesOnStillImagesViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class DetectBarcodesOnStillImagesViewController: UIViewController {
    
    @IBOutlet private var barcodeImageView: UIImageView?
    @IBOutlet private var barcodeTextLabel: UITextView?
    
    private var barcodeScanner: SBSDKBarcodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise the barcode scanner with all barcode types
        barcodeScanner = SBSDKBarcodeScanner(types: SBSDKBarcodeType.allTypes())
        
        // Image containing barcode of type QR-Code
        guard let qrCodeImage = UIImage(named: "QR_Code.jpg") else { return }
        
        // Detect barcode on the provided image
        guard let barcodeScannerResult = barcodeScanner?.detectBarCodes(on: qrCodeImage)?.first else { return }
        
        barcodeImageView?.image = barcodeScannerResult.barcodeImage
        barcodeTextLabel?.text = barcodeScannerResult.rawTextStringWithExtension
    }
}
