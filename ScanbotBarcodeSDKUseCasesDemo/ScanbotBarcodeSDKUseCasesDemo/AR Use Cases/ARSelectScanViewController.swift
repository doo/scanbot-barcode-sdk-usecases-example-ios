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
    private var selectedBarcodes = SBSDKBarcodeItemSelection()

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
        
        // Initialize the barcode scanner view controller
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  configuration: configuration)
        
        // Enable AR tracking overlay and set the delegate
        scannerViewController.isTrackingOverlayEnabled = true
        scannerViewController.trackingOverlayController.delegate = self
        
        // Configure AR tracking overlay for the scanner
        let trackingConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
        
        // If you want to override the default styling of the overlay
        // You can set the style properties of the configuration
        
        // To configure tracked barcodes polygon
        let polygonOverlayStyle = SBSDKBarcodeTrackedViewPolygonStyle()
        polygonOverlayStyle.polygonColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1) //🟡
        polygonOverlayStyle.polygonBackgroundColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 0.2) //🟡
        polygonOverlayStyle.polygonSelectedColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1) //🟢
        polygonOverlayStyle.polygonBackgroundSelectedColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 0.2) //🟢
        
        // Set the configured polygon style
        trackingConfiguration.polygonStyle = polygonOverlayStyle
        
        // To configure tracked barcodes info view
        let textOverlayStyle = SBSDKBarcodeTrackedViewTextStyle()
        textOverlayStyle.textColor = .black
        textOverlayStyle.textBackgroundColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1) //🟡
        textOverlayStyle.highlightedTextColor = .black
        textOverlayStyle.textBackgroundHighlightedColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1) //🟢
        
        // Set the configured info view style
        trackingConfiguration.textStyle = textOverlayStyle
        
        // Set the tracking configuration
        scannerViewController.trackingOverlayController.configuration = trackingConfiguration
    }
}

extension ARSelectScanViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    // Delegate method which provides the tapped barcode.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                didTapOnBarcode barcode: SBSDKBarcodeItem) {
        selectedBarcodes.toggleSelection(for: barcode)
        self.resultListTableView.reloadData()
    }
    
    // Delegate method which asks to provide if the barcode tracking overlay should highlight a barcode.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                shouldHighlight barcode: SBSDKBarcodeItem) -> Bool {
        selectedBarcodes.contains(barcode: barcode)
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
        
        cell.barcodeTextLabel?.text = selectedBarcodes.allBarcodes[indexPath.row].textWithExtension
        cell.barcodeTypeLabel?.text = selectedBarcodes.allBarcodes[indexPath.row].format.name
        cell.barcodeImageView?.image = selectedBarcodes.allBarcodes[indexPath.row].sourceImage?.toUIImage()
        
        return cell
    }
}

