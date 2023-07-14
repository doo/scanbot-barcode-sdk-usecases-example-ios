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
    
    private var scannerViewController: SBSDKBarcodeScannerViewController?
    
    private var barcodeResults = [SBSDKBarcodeScannerResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the barcode scanner
        guard let scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                            parentView: self.scannerView,
                                                                            delegate: self) else { return }
        
        // Enable AR Overlay
        scannerViewController.selectionOverlayEnabled = true
        
        // Enabled automatic selection of the barcodes
        scannerViewController.automaticSelectionEnabled = true
        
        // Configures the scanner to exclude barcode's name and type texts from the AR Overlay
        scannerViewController.selectionOverlayTextFormat = .none
    }
}

extension ARMultiScanViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return true
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        self.barcodeResults = codes
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
        
        cell.barcodeTextLabel?.text = barcodeResults[indexPath.row].rawTextStringWithExtension
        cell.barcodeTypeLabel?.text = barcodeResults[indexPath.row].type.name
        cell.barcodeImageView?.image = barcodeResults[indexPath.row].barcodeImage
        
        return cell
    }
}
