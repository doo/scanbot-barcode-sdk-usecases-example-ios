//
//  ARScanAndCountViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class ARScanAndCountViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    @IBOutlet private var currentBarcodesFound: UILabel!
    @IBOutlet private var totalDifferentBarcodes: UILabel!
    
    private var scannerViewController: SBSDKBarcodeScanAndCountViewController?
    
    private var countedBarcodes = [SBSDKBarcodeScannerAccumulatingResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKBarcodeScanAndCountViewController(parentViewController: self,
                                                                       parentView: self.scannerView,
                                                                       delegate: self)
    }
}

extension ARScanAndCountViewController: SBSDKBarcodeScanAndCountViewControllerDelegate {
    
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             overlayForBarcode code: SBSDKBarcodeScannerResult) -> UIView? {
        return UIImageView(image: UIImage(imageLiteralResourceName: "barcode_checkmark"))
    }
    
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        codes.forEach { code in
            
            guard let existingCode = self.countedBarcodes.first(where: {
                $0.code.type == code.type && $0.code.rawTextString == code.rawTextString
            }) else {
                self.countedBarcodes.append(SBSDKBarcodeScannerAccumulatingResult(barcodeResult: code))
                return
            }
            
            existingCode.scanCount += 1
            existingCode.code.dateOfDetection = code.dateOfDetection
        }
        
        let currentBarcodesFound = codes.count
        let totalDifferentBarcodes = self.countedBarcodes.count
        
        self.currentBarcodesFound.text = "Found barcodes now: \(String(currentBarcodesFound))"
        self.totalDifferentBarcodes.text = "Total different barcodes: \(String(totalDifferentBarcodes))"
    }
}
