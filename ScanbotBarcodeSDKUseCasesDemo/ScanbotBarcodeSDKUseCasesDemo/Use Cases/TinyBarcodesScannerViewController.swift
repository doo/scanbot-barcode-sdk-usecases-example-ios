//
//  TinyBarcodesScannerViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class TinyBarcodesScannerViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    @IBOutlet private var barcodeImageView: UIImageView!
    @IBOutlet private var barcodeTextLabel: UILabel!
    
    // Barcode scanner view controller
    private var scannerViewController: SBSDKBarcodeScannerViewController!
    
    // To store scanned barcode
    private var scannedCode: SBSDKBarcodeItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Barcode formats you want to scan.
        let formatsToScan = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToScan)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Specify whether the barcode result should contain the barcode image.
        configuration.returnBarcodeImage = true
        
        // Initialize the barcode scanner view controller
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.scannerView,
                                                                       configuration: configuration,
                                                                       delegate: self)
        
        // Retrieve the current applied general configurations and modify it
        let generalConfiguration = scannerViewController.generalConfiguration
        generalConfiguration.focusMode = .focusLocked
        generalConfiguration.focusLockLensPosition = 0.1
        
        // Retrieve the view finder configuration of the scanner and modify it
        let viewFinderConfiguration = scannerViewController.viewFinder
        viewFinderConfiguration.isViewFinderEnabled = true
        viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 1, height: 1)
        
        // Apply the modified general configurations onto the scanner
        scannerViewController.generalConfiguration = generalConfiguration
    }
}

extension TinyBarcodesScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        // Get the first code
        guard let code = codes.first else { return }
        
        // Ignore the barcode if it has been scanned before
        guard code.textWithExtension != self.scannedCode?.textWithExtension ||
                code.format != self.scannedCode?.format
        else { return }
        
        self.scannedCode = code
        
        self.barcodeImageView.image = try? scannedCode?.sourceImage?.toUIImage()
        self.barcodeTextLabel.text = scannedCode?.textWithExtension
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didFailScanning error: any Error) {
        if let error = error as? SBSDKError {
            if error.isCanceled {
                print("Scanning was cancelled by the user")
            } else {
                print(error.localizedDescription)
            }
        }
    }
}
