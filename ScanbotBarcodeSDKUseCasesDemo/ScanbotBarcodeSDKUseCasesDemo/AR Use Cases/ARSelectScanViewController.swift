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
        
        // Barcode formats you want to detect.
        let formatsToDetect = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Initialize the barcode scanner view controller
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  configuration: configuration)
        
        // Enable AR tracking overlay and set the delegate
        scannerViewController.isTrackingOverlayEnabled = true
        scannerViewController.trackingOverlayController.delegate = self
        
        // Configure AR tracking overlay for the scanner
        let trackingConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
        trackingConfiguration.isAutomaticSelectionEnabled = false
        trackingConfiguration.isSelectable = true
        
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
        textOverlayStyle.selectedTextColor = .black
        textOverlayStyle.textBackgroundSelectedColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1) //🟢
        
        // Set the configured info view style
        trackingConfiguration.textStyle = textOverlayStyle
        
        // Set the tracking configuration
        scannerViewController.trackingOverlayController.configuration = trackingConfiguration
    }
}

extension ARSelectScanViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    // Delegate method which provides selected barcodes
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                didChangeSelectedBarcodes selectedBarcodes: [SBSDKBarcodeItem]) {
            
        // Process the selected barcodes
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
        cell.barcodeImageView?.image = selectedBarcodes[indexPath.row].sourceImage?.toUIImage()
        
        return cell
    }
}

