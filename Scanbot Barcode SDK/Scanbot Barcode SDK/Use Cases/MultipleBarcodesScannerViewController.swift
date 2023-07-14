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
    
    private var scannerViewController: SBSDKBarcodeScannerViewController?
    
    private var barcodeResults = [SBSDKBarcodeScannerResult]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: self.scannerView,
                                                                  delegate: self)
    }
}

extension MultipleBarcodesScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
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
        
        cell.barcodeTextLabel?.text = barcodeResults[indexPath.row].rawTextStringWithExtension
        cell.barcodeTypeLabel?.text = barcodeResults[indexPath.row].type.name
        cell.barcodeImageView?.image = barcodeResults[indexPath.row].barcodeImage
        
        return cell
    }
}
