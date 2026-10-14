//
//  ARFindAndPickViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class ARFindAndPickViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    
    // Barcode scanner view controller
    private var scannerViewController: SBSDKBarcodeScannerViewController!

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
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  configuration: configuration)
        
        // Enable AR tracking overlay and set the delegate
        scannerViewController.viewModel.trackingOverlay.isTrackingOverlayEnabled = true
        scannerViewController.viewModel.trackingOverlay.delegate = self
    }
}

extension ARFindAndPickViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    // Delegate method to provide a custom style for a tracked barcode.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                styleFor item: SBSDKBarcodeTrackingOverlayItem,
                                proposedStyle: SBSDKBarcodeTrackingOverlayStyle) -> SBSDKBarcodeTrackingOverlayStyle {
        
        // Provide custom style for the tracked barcode
        let style = SBSDKBarcodeTrackingOverlayStyle()
        
        // Enable the polygon and disable the info view
        style.polygonDrawingEnabled = true
        style.textDrawingEnabled = false
        
        // Green color for QR code and white for the rest of the barcode types
        if item.barcode.format == SBSDKBarcodeFormat.qrCode {
            style.polygonColor = .green
            style.polygonBackgroundColor = .green.withAlphaComponent(0.2)
        } else {
            style.polygonColor = .white
            style.polygonBackgroundColor = .white.withAlphaComponent(0.2)
        }
        
        return style
    }
}

extension ARFindAndPickViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerControllerShouldScanBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return true
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
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
