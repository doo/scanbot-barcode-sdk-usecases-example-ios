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
        scannerViewController.isTrackingOverlayEnabled = true
        scannerViewController.trackingOverlayController.delegate = self
    }
}

extension ARFindAndPickViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    // Delegate method to provide a custom style for a tracked barcodes polygon.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                polygonStyleFor barcode: SBSDKBarcodeItem,
                                proposedStyle: SBSDKBarcodeTrackedViewPolygonStyle) -> SBSDKBarcodeTrackedViewPolygonStyle {
        
        // Provide custom style for tracked barcodes polygon
        let polygonStyle = SBSDKBarcodeTrackedViewPolygonStyle()
        polygonStyle.polygonDrawingEnabled = true
        
        // Green color for QR code and white for the rest of the barcode types
        if barcode.format == SBSDKBarcodeFormat.qrCode {
            polygonStyle.polygonColor = .green
            polygonStyle.polygonBackgroundColor = .green.withAlphaComponent(0.2)
        } else {
            polygonStyle.polygonColor = .white
            polygonStyle.polygonBackgroundColor = .white.withAlphaComponent(0.2)
        }
        
        return polygonStyle
    }
    
    // Delegate method to provide a custom style for a tracked barcodes info view
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                textStyleFor barcode: SBSDKBarcodeItem,
                                proposedStyle: SBSDKBarcodeTrackedViewTextStyle) -> SBSDKBarcodeTrackedViewTextStyle {
        
        // Provide custom style for tracked barcodes info view
        let textStyle = SBSDKBarcodeTrackedViewTextStyle()
        textStyle.textDrawingEnabled = false
        
        return textStyle
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
