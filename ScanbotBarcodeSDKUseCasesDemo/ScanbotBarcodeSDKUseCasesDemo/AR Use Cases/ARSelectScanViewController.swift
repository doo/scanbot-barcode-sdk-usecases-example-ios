//
//  ARSelectScanViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class ARSelectScanViewController: UIViewController {
    
    @IBOutlet private var scannerView: UIView!
    @IBOutlet private var resultListTableView: UITableView!
    
    // Barcode scanner view controller
    private var scannerViewController: SBSDKBarcodeScannerViewController!
    
    // To store selected barcodes
    private var selectedBarcodes = [SBSDKBarcodeItem]()

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
                                                                  configuration: configuration)
        
        // Enable AR tracking overlay and set the delegate
        scannerViewController.viewModel.trackingOverlay.isTrackingOverlayEnabled = true
        scannerViewController.viewModel.trackingOverlay.delegate = self
        
        // Configure AR tracking overlay for the scanner
        let trackingConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
        
        // Allow the user to select multiple tracked barcodes by tapping on them
        trackingConfiguration.selectionMode = .multiple
        
        // If you want to override the default styling of the overlay
        // You can set the style properties of the configuration
        
        // The style applied to the tracked barcodes that are not selected
        let defaultStyle = SBSDKBarcodeTrackingOverlayStyle()
        defaultStyle.polygonColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1) //🟡
        defaultStyle.polygonBackgroundColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 0.2) //🟡
        defaultStyle.textColor = .black
        defaultStyle.textBackgroundColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1) //🟡
        
        // Set the configured style as the default style
        trackingConfiguration.defaultStyle = defaultStyle
        
        // The style applied to the tracked barcodes that are selected
        let selectionStyle = SBSDKBarcodeTrackingOverlayStyle()
        selectionStyle.polygonColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1) //🟢
        selectionStyle.polygonBackgroundColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 0.2) //🟢
        selectionStyle.textColor = .black
        selectionStyle.textBackgroundColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1) //🟢
        
        // Set the configured style as the selection style
        trackingConfiguration.selectionStyle = selectionStyle
        
        // Set the tracking configuration
        scannerViewController.viewModel.trackingOverlay.trackingOverlayConfiguration = trackingConfiguration
    }
}

extension ARSelectScanViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    // Delegate method which provides the currently selected barcodes.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                didChangeSelection selectedBarcodes: [SBSDKBarcodeItem]) {
        self.selectedBarcodes = selectedBarcodes
        self.resultListTableView.reloadData()
    }
}

extension ARSelectScanViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedBarcodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeResultCell", for: indexPath) as!
        BarcodeResultTableViewCell
        
        cell.barcodeTextLabel?.text = selectedBarcodes[indexPath.row].textWithExtension
        cell.barcodeTypeLabel?.text = selectedBarcodes[indexPath.row].format.name
        cell.barcodeImageView?.image = try? selectedBarcodes[indexPath.row].sourceImage?.toUIImage()
        
        return cell
    }
}

