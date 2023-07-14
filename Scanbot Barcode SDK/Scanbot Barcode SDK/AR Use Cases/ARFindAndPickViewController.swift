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
        
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  delegate: self)
        
        guard let scannerViewController else { return }
        
        scannerViewController.selectionOverlayEnabled = true
        scannerViewController.automaticSelectionEnabled = true
        scannerViewController.selectionOverlayTextFormat = .none
        
        scannerViewController.selectionPolygonColor = .white
        
        scannerViewController.selectionHighlightedPolygonColor = .green
    }
}

extension ARFindAndPickViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return true
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  shouldHighlight code: SBSDKBarcodeScannerResult) -> Bool {
        
        return code.type == SBSDKBarcodeTypeQRCode
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
    }
}
