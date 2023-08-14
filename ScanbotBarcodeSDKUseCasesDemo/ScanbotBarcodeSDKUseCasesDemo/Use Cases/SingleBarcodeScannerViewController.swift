//
//  SingleBarcodeScannerViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 12.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class SingleBarcodeScannerViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    
    @IBOutlet private var barcodeImageView: UIImageView!
    @IBOutlet private var barcodeTextLabel: UILabel!
    
    // Barcode scanner view controller
    private var scannerViewController: SBSDKBarcodeScannerViewController?
    
    private var detectedCode: SBSDKBarcodeScannerResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the barcode scanner view controller
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.scannerView,
                                                                       delegate: self)
        guard let scannerViewController else { return }
        
        // Retrieve the current applied view finder configurations and modify it
        let viewFinderConfiguration = scannerViewController.viewFinderConfiguration
        viewFinderConfiguration.isViewFinderEnabled = true
        viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 1, andHeight: 1)
        
        // Apply the modified view finder configurations onto the scanner
        scannerViewController.viewFinderConfiguration = viewFinderConfiguration
    }
}

extension SingleBarcodeScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        // Get the first code
        guard let code = codes.first else { return }
        
        // Ignore the barcode if it is same as the last one
        guard code.rawTextStringWithExtension != self.detectedCode?.rawTextStringWithExtension ||
              code.type != self.detectedCode?.type
        else { return }
        
        self.detectedCode = code
        
        self.barcodeImageView.image = detectedCode?.barcodeImage
        self.barcodeTextLabel.text = detectedCode?.rawTextStringWithExtension
    }
}
