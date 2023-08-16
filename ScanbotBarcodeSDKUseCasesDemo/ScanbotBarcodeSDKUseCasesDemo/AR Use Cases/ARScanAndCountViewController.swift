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
    
    // Barcode scan and count view controller
    private var scannerViewController: SBSDKBarcodeScanAndCountViewController!
    
    // To store counted barcodes
    private var countedBarcodes = [SBSDKBarcodeScannerAccumulatingResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the barcode scanner view controller
        scannerViewController = SBSDKBarcodeScanAndCountViewController(parentViewController: self,
                                                                       parentView: self.scannerView,
                                                                       delegate: self)
        
        // Get current polygon style.
        let polygonStyle = self.scannerViewController.polygonStyle
        
        // Enable the barcode polygon overlay.
        polygonStyle.polygonDrawingEnabled = true
        
        // Set the color for the polygons.
        polygonStyle.polygonColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.8)
        
        // Set the color for the polygon's fill color.
        polygonStyle.polygonFillColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.2)
        
        // Set the line width for the polygons.
        polygonStyle.lineWidth = 2
        
        // Set the corner radius for the polygons.
        polygonStyle.cornerRadius = 8
        
        // Set the polygon style to apply it.
        self.scannerViewController.polygonStyle = polygonStyle
        
        // Set the capture mode of the scanner.
        self.scannerViewController.captureMode = .capturedImage
    }
}

extension ARScanAndCountViewController: SBSDKBarcodeScanAndCountViewControllerDelegate {
    
    // Delegate method which asks for a view of type UIView
    // Which then will be used as an overlay for the specific barcode 
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             overlayForBarcode code: SBSDKBarcodeScannerResult) -> UIView? {
        
        // Provide overlay view for the the AR overlay
        return UIImageView(image: UIImage(imageLiteralResourceName: "barcode_checkmark"))
    }
    
    // Delegate method which provides detected barcodes
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        // Check if the code is new or has been detected before
        codes.forEach { code in
            
            guard let existingCode = self.countedBarcodes.first(where: {
                $0.code.type == code.type && $0.code.rawTextString == code.rawTextString
                
            }) else {
                
                // If the code is new
                self.countedBarcodes.append(SBSDKBarcodeScannerAccumulatingResult(barcodeResult: code))
                return
            }
            
            // If the code is not new, update it's `scanCount`
            existingCode.scanCount += 1
        }
        
        let currentBarcodesFound = codes.count
        let totalDifferentBarcodes = self.countedBarcodes.count
        
        self.currentBarcodesFound.text = "Found barcodes now: \(String(currentBarcodesFound))"
        self.totalDifferentBarcodes.text = "Total different barcodes: \(String(totalDifferentBarcodes))"
    }
}
