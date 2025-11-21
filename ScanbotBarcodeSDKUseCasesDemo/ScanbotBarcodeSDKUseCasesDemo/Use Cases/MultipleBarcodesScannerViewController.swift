//
//  MultipleBarcodesScannerViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class MultipleBarcodesScannerViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    @IBOutlet private var resultListTableView: UITableView!
    
    // Barcode scanner view controller
    private var scannerViewController: SBSDKBarcodeScannerViewController!
    
    // To store scanned barcodes
    private var barcodeResults = [SBSDKBarcodeItem]()

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
                                                                  configuration: configuration,
                                                                  delegate: self)
    }
}

extension MultipleBarcodesScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        // Ignore barcodes that have already been scanned
        codes.forEach { scannedBarcode in
            
            // Check scanned barcode's name, extension, and type with previously scanned barcodes
            // Ignore barcode if it has already been scanned
            if !self.barcodeResults.contains(barcode: scannedBarcode) {
                self.barcodeResults.append(scannedBarcode)
            }
        }
        
        self.resultListTableView.reloadData()
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

extension MultipleBarcodesScannerViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        cell.barcodeImageView?.image = try? barcodeResults[indexPath.row].sourceImage?.toUIImage()
        
        return cell
    }
}
