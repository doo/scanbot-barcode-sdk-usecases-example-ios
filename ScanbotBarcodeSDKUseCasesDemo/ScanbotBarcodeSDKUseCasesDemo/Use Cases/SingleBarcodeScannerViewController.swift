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
    private var scannerViewController: SBSDKBarcodeScannerViewController!
    
    private var detectedCode: SBSDKBarcodeItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Barcode formats you want to detect.
        let formatsToDetect = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Initialize the barcode scanner view controller
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.scannerView,
                                                                       configuration: configuration,
                                                                       delegate: self)
        
        // Retrieve the current applied view finder configurations and modify it
        let viewFinderConfiguration = scannerViewController.viewFinderConfiguration
        viewFinderConfiguration.isViewFinderEnabled = true
        viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 1, height: 1)
        
        // Apply the modified view finder configurations onto the scanner
        scannerViewController.viewFinderConfiguration = viewFinderConfiguration
    }
}

extension SingleBarcodeScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeItem]) {
        // Get the first code
        guard let code = codes.first else { return }
        
        // Ignore the barcode if it is same as the last one
        guard code.textWithExtension != self.detectedCode?.textWithExtension ||
                code.format != self.detectedCode?.format
        else { return }
        
        self.detectedCode = code
        
        self.barcodeImageView.image = detectedCode?.sourceImage?.toUIImage()
        self.barcodeTextLabel.text = detectedCode?.textWithExtension
    }
}
