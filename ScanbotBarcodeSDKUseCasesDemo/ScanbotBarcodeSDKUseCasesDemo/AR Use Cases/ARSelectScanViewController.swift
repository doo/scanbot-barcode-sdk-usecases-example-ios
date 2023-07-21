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
        guard let scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                            parentView: self.scannerView,
                                                                            delegate: self) else { return }
        
        // Enable AR Overlay
        scannerViewController.selectionOverlayEnabled = true
        
        // Disable automatic selection of the barcodes
        scannerViewController.automaticSelectionEnabled = false
        
        // Configures the scanner to exclude barcode's type text from the AR Overlay
        scannerViewController.selectionOverlayTextFormat = .code
        
        // Set non highlighted (non-selected) colors for the AR Overlay
        scannerViewController.selectionPolygonColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1)
        scannerViewController.selectionTextColor = .black
        scannerViewController.selectionTextContainerColor = UIColor(red: 255/255, green: 187/255, blue: 51/255, alpha: 1)
        
        // Set highlighted (selected) colors for the AR Overlay
        scannerViewController.selectionHighlightedPolygonColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1)
        scannerViewController.selectionHighlightedTextColor = .black
        scannerViewController.selectionHighlightedTextContainerColor = UIColor(red: 85/255, green: 187/255, blue: 119/255, alpha: 1)
    }
}

extension ARSelectScanViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return true
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  shouldHighlight code: SBSDKBarcodeScannerResult) -> Bool {
        
        // Highlight the code if it has been selected
        return self.selectedBarcodes.contains(barcode: code)
    }
    
    // Delegate method which provides detected barcodes
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        // When `selectionOverlayEnabled` is set to true
        // And `automaticSelectionEnabled` is set to false
        // Then this method only gets called when the barcode is selected
        
        // The passed parameter `codes` only contains the barcode which is selected
        guard let selectedBarcode = codes.first else { return }
        
        // Check selected barcode's name, extension, and type with previously selected barcodes
        // Ignore the barcode If it has already been selected
        if !self.selectedBarcodes.contains(barcode: selectedBarcode) {
            self.selectedBarcodes.append(selectedBarcode)
        }
        
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

