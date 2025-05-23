//
//  ARBarcodeVisionViewController.swift
//  ScanbotBarcodeSDKUseCasesDemo
//
//  Created by Rana Sohaib on 10.08.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

class ARBarcodeVisionViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    
    // Barcode scanner view controller
    private var scannerViewController: SBSDKBarcodeScannerViewController!
    
    override func viewDidLoad() {
        
        // Barcode formats you want to detect.
        let formatsToDetect = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Initialize the barcode scanner view controller
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  configuration: configuration)
        
        // Enable tracking overlay
        scannerViewController.isTrackingOverlayEnabled = true
        
        // Load your custom view
        let view = UINib(nibName: "ARCustomOverlayView",
                         bundle: nil).instantiate(withOwner: nil).first as? ARCustomOverlayView
        
        // Configure AR Tracking overlay for the scanner
        let trackingConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
        
        // Register your custom view
        trackingConfiguration.customView = view
        
        // Set the configuration
        scannerViewController.trackingOverlayController.configuration = trackingConfiguration
    }
}
