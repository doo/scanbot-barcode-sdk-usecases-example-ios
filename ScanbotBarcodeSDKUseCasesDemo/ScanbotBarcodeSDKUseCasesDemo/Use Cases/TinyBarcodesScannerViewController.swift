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
    
    // To store detected barcode
    private var detectedCode: SBSDKBarcodeScannerResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the barcode scanner view controller
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.scannerView,
                                                                       delegate: self)
        
        // Retrieve the current applied general configurations and modify it
        let generalConfiguration = scannerViewController.generalConfiguration
        generalConfiguration.isFocusLockEnabled = true
        generalConfiguration.focusLockPosition = 0.1
        
        // Retrieve the current applied view finder configurations and modify it
        let viewFinderConfiguration = scannerViewController.viewFinderConfiguration
        viewFinderConfiguration.isViewFinderEnabled = true
        viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 1, andHeight: 1)
        
        // Apply the modified general configurations onto the scanner
        scannerViewController.generalConfiguration = generalConfiguration
        
        // Apply the modified view finder configurations onto the scanner
        scannerViewController.viewFinderConfiguration = viewFinderConfiguration
    }
}

extension TinyBarcodesScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        // Get the first code
        guard let code = codes.first else { return }
        
        // Ignore the barcode if it has been detected before
        guard code.rawTextStringWithExtension != self.detectedCode?.rawTextStringWithExtension ||
              code.type != self.detectedCode?.type
        else { return }
        
        self.detectedCode = code
        
        self.barcodeImageView.image = detectedCode?.barcodeImage
        self.barcodeTextLabel.text = detectedCode?.rawTextStringWithExtension
    }
}
