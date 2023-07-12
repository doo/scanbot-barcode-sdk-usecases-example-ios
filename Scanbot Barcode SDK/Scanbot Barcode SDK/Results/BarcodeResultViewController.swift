//
//  BarcodeResultViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

final class BarcodeResultViewController: UITableViewController {
    
    var results: [SBSDKBarcodeScannerResult]?
    
    private var selectedBarcodeImage: UIImage?
    private var selectedBarcodeText: String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BarcodeResultDetailsViewController {
            controller.barcodeImage = selectedBarcodeImage
            controller.barcodeText = selectedBarcodeText
        }
    }
}

extension BarcodeResultViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeResultCell", for: indexPath) as!
        BarcodeResultTableViewCell
        
        cell.barcodeTextLabel?.text = results?[indexPath.row].rawTextStringWithExtension
        cell.barcodeTypeLabel?.text = results?[indexPath.row].type.name
        cell.barcodeImageView?.image = results?[indexPath.row].barcodeImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedBarcodeImage = results?[indexPath.row].barcodeImage
        selectedBarcodeText = results?[indexPath.row].rawTextStringWithExtension
        
        performSegue(withIdentifier: "barcodeResultDetails", sender: nil)
    }
}

extension BarcodeResultViewController {
    
    static func make(results: [SBSDKBarcodeScannerResult]) -> BarcodeResultViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultViewController = storyboard.instantiateViewController(withIdentifier: "barcodeResultViewController")
        as! BarcodeResultViewController
        
        resultViewController.results = results
        
        return resultViewController
    }
}
