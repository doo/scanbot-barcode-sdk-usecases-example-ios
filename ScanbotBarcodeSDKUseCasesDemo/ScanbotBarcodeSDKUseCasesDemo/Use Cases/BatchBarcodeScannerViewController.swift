//
//  BatchBarcodeScannerViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class BatchBarcodeScannerViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    @IBOutlet private var resultListTableView: UITableView!
    
    // Initialize the barcode scanner view controller
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
        
        // Specify whether the barcode result should contain the barcode image.
        configuration.returnBarcodeImage = true
        
        // Initialize the barcode scanner
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.scannerView,
                                                                       configuration: configuration,
                                                                       delegate: self)
        
        // Retrieve the current applied view finder configurations and modify it
        let viewFinderConfiguration = scannerViewController.viewFinderConfiguration
        viewFinderConfiguration.isViewFinderEnabled = true
        viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 1, height: 1)
        
        // Apply the modified view finder configurations onto the scanner
        scannerViewController.viewFinderConfiguration = viewFinderConfiguration
    }
}

extension BatchBarcodeScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
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

extension BatchBarcodeScannerViewController: UITableViewDataSource, UITableViewDelegate {
    
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

