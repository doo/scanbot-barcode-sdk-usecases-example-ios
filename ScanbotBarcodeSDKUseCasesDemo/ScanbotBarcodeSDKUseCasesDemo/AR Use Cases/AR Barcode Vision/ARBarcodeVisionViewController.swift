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
        
        // Initialize the barcode scanner view controller
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView)
        
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
