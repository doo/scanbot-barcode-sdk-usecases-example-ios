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
    private var scannerViewController: SBSDKBarcodeScannerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the barcode scanner view controller
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                            parentView: self.scannerView)
        
        // Enable AR tracking overlay and set the delegate
        scannerViewController?.isTrackingOverlayEnabled = true
        scannerViewController?.trackingOverlayController.delegate = self
        
        // Configure AR tracking overlay for the scanner
        let trackingConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
        trackingConfiguration.isAutomaticSelectionEnabled = false
        trackingConfiguration.isSelectable = false
        
        // Set the tracking configuration
        scannerViewController?.trackingOverlayController.configuration = trackingConfiguration
    }
}

extension ARFindAndPickViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    // Delegate method to provide a custom style for a tracked barcodes polygon
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                polygonStyleFor barcode: SBSDKBarcodeScannerResult) -> SBSDKBarcodeTrackedViewPolygonStyle? {
        
        // Provide custom style for tracked barcodes polygon
        let polygonStyle = SBSDKBarcodeTrackedViewPolygonStyle()
        polygonStyle.polygonDrawingEnabled = true
        
        // Green color for QR code and white for the rest of the barcode types
        if barcode.type == SBSDKBarcodeTypeQRCode {
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
                                textStyleFor barcode: SBSDKBarcodeScannerResult) -> SBSDKBarcodeTrackedViewTextStyle? {
        
        // Provide custom style for tracked barcodes info view
        let textStyle = SBSDKBarcodeTrackedViewTextStyle()
        textStyle.textDrawingEnabled = false
        
        return textStyle
    }
}

extension ARFindAndPickViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return true
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
    }
}
