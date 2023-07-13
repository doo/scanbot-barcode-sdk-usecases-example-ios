//
//  DistantBarcodesScannerViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class DistantBarcodesScannerViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    @IBOutlet private var barcodeImageView: UIImageView!
    @IBOutlet private var barcodeTextLabel: UILabel!
    
    private var scannerViewController: SBSDKBarcodeScannerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  delegate: self)
        
        let zoomConfiguration = scannerViewController.zoomConfiguration
        zoomConfiguration.initialZoomFactor = 1.0
        
        let viewFinderConfiguration = scannerViewController.viewFinderConfiguration
        viewFinderConfiguration.isViewFinderEnabled = true
        viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 1, andHeight: 1)
        
        scannerViewController.zoomConfiguration = zoomConfiguration
        scannerViewController.viewFinderConfiguration = viewFinderConfiguration
    }
}

extension DistantBarcodesScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        guard let code = codes.first else { return }
        
        self.barcodeImageView.image = code.barcodeImage
        self.barcodeTextLabel.text = code.rawTextStringWithExtension
    }
}
