//
//  DetectBarcodesOnStillImagesViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import PhotosUI
import ScanbotBarcodeScannerSDK

final class DetectBarcodesOnStillImagesViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    // Barcode scanner
    private var barcodeScanner: SBSDKBarcodeScanner?
    
    // To store detected barcodes
    private var barcodeScannerResults = [SBSDKBarcodeItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise the barcode scanner with all barcode types
        barcodeScanner = SBSDKBarcodeScanner(formats: SBSDKBarcodeFormats.all)
    }
    
    func detectBarcode(OnImage image: UIImage) {
        
        // Detect barcodes on the provided image
        guard let results = barcodeScanner?.detectBarcodes(on: image) else { return }
        
        self.barcodeScannerResults = results.barcodes
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension DetectBarcodesOnStillImagesViewController {
    
    @IBAction func importButtonTapped(_ sender: UIBarButtonItem) {
        
        if #available(iOS 14.0, *) {
            
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            self.present(picker, animated: true)
            
        } else {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
}

extension DetectBarcodesOnStillImagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodeScannerResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeResultCell")
            as? BarcodeResultTableViewCell {
            
            cell.barcodeImageView.image = self.barcodeScannerResults[indexPath.row].sourceImage?.toUIImage()
            cell.barcodeTextLabel.text = self.barcodeScannerResults[indexPath.row].textWithExtension
            cell.barcodeTypeLabel.text = self.barcodeScannerResults[indexPath.row].format.name
            
            return cell
        }
        return UITableViewCell()
    }
}

@available(iOS 14.0, *)
extension DetectBarcodesOnStillImagesViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                
                guard let image = image as? UIImage else {
                    return
                }
                self?.detectBarcode(OnImage: image)
            }
        }
    }
}

// TODO: Remove in case we drop iOS 13.0
extension DetectBarcodesOnStillImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.detectBarcode(OnImage: image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
