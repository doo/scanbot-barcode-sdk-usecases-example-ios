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
    
    private var scannerViewController: SBSDKBarcodeScannerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the barcode scanner
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                            parentView: self.scannerView)
        
        // Enable AR Tracking Overlay and set the delegate
        scannerViewController?.isTrackingOverlayEnabled = true
        scannerViewController?.trackingOverlayController.delegate = self
        
        // Configure AR Tracking Overlay for the scanner
        let trackingConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
        trackingConfiguration.isAutomaticSelectionEnabled = false
        trackingConfiguration.isSelectable = false
        
        // Set the configuration
        scannerViewController?.trackingOverlayController.configuration = trackingConfiguration
    }
}

extension ARFindAndPickViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                polygonStyleFor barcode: SBSDKBarcodeScannerResult) -> SBSDKBarcodeTrackedViewPolygonStyle? {
        
        // To configure polygon style for the received barcode
        let polygonStyle = SBSDKBarcodeTrackedViewPolygonStyle()
        polygonStyle.polygonDrawingEnabled = true
        
        // Green color for qr code and white for the rest of the barcode types
        if barcode.type == SBSDKBarcodeTypeQRCode {
            polygonStyle.polygonColor = .green
            polygonStyle.polygonBackgroundColor = .green.withAlphaComponent(0.2)
        } else {
            polygonStyle.polygonColor = .white
            polygonStyle.polygonBackgroundColor = .white.withAlphaComponent(0.2)
        }
        
        return polygonStyle
    }
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                textStyleFor barcode: SBSDKBarcodeScannerResult) -> SBSDKBarcodeTrackedViewTextStyle? {
        // Disable the text for the overlay
        let textStyle = SBSDKBarcodeTrackedViewTextStyle()
        textStyle.textDrawingEnabled = false
        
        return textStyle
    }
}

extension ARFindAndPickViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return true
    }
    
    // Delegate method which asks whether to highlight a specific barcode
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  shouldHighlight code: SBSDKBarcodeScannerResult) -> Bool {
        
        // Only highlight the QR-Codes
        return code.type == SBSDKBarcodeTypeQRCode
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
    }
}
