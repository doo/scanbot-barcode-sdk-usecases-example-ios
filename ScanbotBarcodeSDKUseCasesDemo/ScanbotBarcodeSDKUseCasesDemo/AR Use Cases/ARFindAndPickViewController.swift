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
        guard let scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                            parentView: self.scannerView,
                                                                            delegate: self) else { return }
        
        // Enable AR Overlay
        scannerViewController.selectionOverlayEnabled = true
        
        // Enabled automatic selection of the barcodes
        scannerViewController.automaticSelectionEnabled = true
        
        // Configures the scanner to exclude barcode's name and type texts from the AR Overlay
        scannerViewController.selectionOverlayTextFormat = .none
        
        // Set non highlighted color for the AR OVerlay
        scannerViewController.selectionPolygonColor = .white
        
        // Set highlighted color for the AR OVerlay
        scannerViewController.selectionHighlightedPolygonColor = .green
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
