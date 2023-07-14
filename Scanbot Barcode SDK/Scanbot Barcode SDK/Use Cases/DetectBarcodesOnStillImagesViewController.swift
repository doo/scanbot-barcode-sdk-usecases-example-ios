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
        
        barcodeScanner = SBSDKBarcodeScanner(types: SBSDKBarcodeType.allTypes())
        
        guard let qrCodeImage = UIImage(named: "QR_Code.jpg") else { return }
        
        guard let barcodeScannerResult = barcodeScanner?.detectBarCodes(on: qrCodeImage)?.first else { return }
        
        barcodeImageView?.image = barcodeScannerResult.barcodeImage
        barcodeTextLabel?.text = barcodeScannerResult.rawTextStringWithExtension
    }
}
