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
    
    private var scannerViewController: SBSDKBarcodeScannerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the barcode scanner
        guard let scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                            parentView: self.scannerView,
                                                                            delegate: self) else { return }
        
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
        
        guard let code = codes.first else { return }
        
        self.barcodeImageView.image = code.barcodeImage
        self.barcodeTextLabel.text = code.rawTextStringWithExtension
    }
}
