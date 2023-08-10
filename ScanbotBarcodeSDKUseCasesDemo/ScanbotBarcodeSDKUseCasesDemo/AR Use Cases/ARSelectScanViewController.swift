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
    
    private var scannerViewController: SBSDKBarcodeScannerViewController?
    
    private var selectedBarcodes = [SBSDKBarcodeScannerResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the barcode scanner
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView)
        
        // Enable AR Tracking Overlay and set the delegate
        scannerViewController?.isTrackingOverlayEnabled = true
        scannerViewController?.trackingOverlayController.delegate = self
        
        // Configure AR Tracking Overlay for the scanner
        let trackingConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
        trackingConfiguration.isAutomaticSelectionEnabled = false
        trackingConfiguration.isSelectable = true
        
        // If you want to override the default styling of the overlays
        // You can set the style properties of the configuration
        // To set the style of the polygon overlay
        let polygonOverlayStyle = SBSDKBarcodeTrackedViewPolygonStyle()
        polygonOverlayStyle.polygonColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1) //🟡
        polygonOverlayStyle.polygonBackgroundColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 0.2) //🟡
        polygonOverlayStyle.polygonSelectedColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1) //🟢
        polygonOverlayStyle.polygonBackgroundSelectedColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 0.2) //🟢
        
        // Set the configured polygon overlay style
        trackingConfiguration.polygonStyle = polygonOverlayStyle
        
        // To set the style of the text overlay
        let textOverlayStyle = SBSDKBarcodeTrackedViewTextStyle()
        textOverlayStyle.textColor = .black
        textOverlayStyle.textBackgroundColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1) //🟡
        textOverlayStyle.selectedTextColor = .black
        textOverlayStyle.textBackgroundSelectedColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1) //🟢
        
        // Set the configured text overlay style
        trackingConfiguration.textStyle = textOverlayStyle
        
        // Set the configuration
        scannerViewController?.trackingOverlayController.configuration = trackingConfiguration
    }
}

extension ARSelectScanViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                didChangeSelectedBarcodes selectedBarcodes: [SBSDKBarcodeScannerResult]) {
            
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
        
        cell.barcodeTextLabel?.text = selectedBarcodes[indexPath.row].rawTextStringWithExtension
        cell.barcodeTypeLabel?.text = selectedBarcodes[indexPath.row].type.name
        cell.barcodeImageView?.image = selectedBarcodes[indexPath.row].barcodeImage
        
        return cell
    }
}

