//
//  ARMultiScanViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class ARMultiScanViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    @IBOutlet private var resultListTableView: UITableView!
    
    // Barcode scanner view controller
    private var scannerViewController: SBSDKBarcodeScannerViewController!
    
    // To store detected barcodes
    private var barcodeResults = [SBSDKBarcodeItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Barcode formats you want to detect.
        let formatsToDetect = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Initialize the barcode scanner view controller
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  configuration: configuration,
                                                                  delegate: self)
        
        // Enable AR tracking overlay
        scannerViewController.isTrackingOverlayEnabled = true

        // Configure AR tracking overlay for the scanner
        let trackingConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
        trackingConfiguration.isAutomaticSelectionEnabled = true
        trackingConfiguration.isSelectable = false

        // To configure tracked barcodes info view
        let trackedViewTextStyle = SBSDKBarcodeTrackedViewTextStyle()
        
        // To disable the info view
        trackedViewTextStyle.textDrawingEnabled = false

        // Set the configured info view style
        trackingConfiguration.textStyle = trackedViewTextStyle

        // Set the tracking configuration
        scannerViewController.trackingOverlayController.configuration = trackingConfiguration
    }
}

extension ARMultiScanViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        // Ignore barcodes that have already been detected
        codes.forEach { detectedBarcode in
            
            // Check detected barcode's name, extension, and type with previously detected barcodes
            // Ignore barcode if it has already been detected
            if !self.barcodeResults.contains(barcode: detectedBarcode) {
                self.barcodeResults.append(detectedBarcode)
            }
        }
        
        self.resultListTableView.reloadData()
    }
}

extension ARMultiScanViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.barcodeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeResultCell", for: indexPath) as!
        BarcodeResultTableViewCell
        
        cell.barcodeTextLabel?.text = barcodeResults[indexPath.row].textWithExtension
        cell.barcodeTypeLabel?.text = barcodeResults[indexPath.row].format.name
        cell.barcodeImageView?.image = barcodeResults[indexPath.row].sourceImage?.toUIImage()
        
        return cell
    }
}
