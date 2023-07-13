//
//  BarcodeResultDetailsViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

class BarcodeResultDetailsViewController: UIViewController {
    
    var barcodeImage: UIImage?
    var barcodeText: String?
    
    @IBOutlet private var barcodeImageView: UIImageView?
    @IBOutlet private var barcodeTextLabel: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcodeImageView?.image = barcodeImage
        barcodeTextLabel?.text = barcodeText
    }
}

extension BarcodeResultDetailsViewController {
    static func make(code: SBSDKBarcodeScannerResult) -> BarcodeResultDetailsViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "barcodeResultDetailViewController")
        as! BarcodeResultDetailsViewController
        
        viewController.barcodeImage = code.barcodeImage
        viewController.barcodeText = code.rawTextStringWithExtension
        
        return viewController
    }
}
