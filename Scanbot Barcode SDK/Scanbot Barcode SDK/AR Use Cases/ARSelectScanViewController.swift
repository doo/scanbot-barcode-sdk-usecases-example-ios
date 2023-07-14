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
    
    private var barcodeResults = [SBSDKBarcodeScannerResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  delegate: self)
        
        guard let scannerViewController else { return }
        
        scannerViewController.selectionOverlayEnabled = true
        scannerViewController.automaticSelectionEnabled = false
        scannerViewController.selectionOverlayTextFormat = .code
        
        scannerViewController.selectionPolygonColor = .red
        scannerViewController.selectionTextColor = .black
        scannerViewController.selectionTextContainerColor = .red
        
        scannerViewController.selectionHighlightedPolygonColor = .green
        scannerViewController.selectionHighlightedTextColor = .black
        scannerViewController.selectionHighlightedTextContainerColor = .green
    }
}

extension ARSelectScanViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return true
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  shouldHighlight code: SBSDKBarcodeScannerResult) -> Bool {
        
        if self.barcodeResults.contains(where: { previouslyDetectedCode in
            previouslyDetectedCode.rawTextStringWithExtension == code.rawTextStringWithExtension &&
            previouslyDetectedCode.type == code.type
        }) {
            return true
        } else {
            return false
        }
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        codes.forEach { newBarcodeResult in
            if !self.barcodeResults.contains(where: { previouslyDetectedCode in
                previouslyDetectedCode.rawTextStringWithExtension == newBarcodeResult.rawTextStringWithExtension &&
                previouslyDetectedCode.type == newBarcodeResult.type
            }) {
                self.barcodeResults.append(newBarcodeResult)
            }
        }
        
        self.resultListTableView.reloadData()
    }
}

extension ARSelectScanViewController: UITableViewDataSource, UITableViewDelegate {
    
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

