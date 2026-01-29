//
//  ScanBarcodesOnStillImagesViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 13.07.23.
//

import UIKit
import PhotosUI
import ScanbotBarcodeScannerSDK

final class ScanBarcodesOnStillImagesViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    // Barcode scanner
    private var barcodeScanner: SBSDKBarcodeScanner?
    
    // To store scanned barcodes
    private var barcodeScannerResults = [SBSDKBarcodeItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create barcode scanner configuration.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormats: SBSDKBarcodeFormats.all)
        
        do {
            // Initialise the barcode scanner using the configuration.
            barcodeScanner = try SBSDKBarcodeScanner(configuration: configuration)
        }
        catch {
            print("Error initializing barcode scanner: \(error.localizedDescription)")
        }
    }
    
    func scanBarcode(on image: UIImage) {
        guard let barcodeScanner else { return }
        
        do {
            // Convert `UIImage` to `SBSDKImageRef`.
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            
            // Scan barcodes on the provided image
            let results = try barcodeScanner.run(image: imageRef)
            
            self.barcodeScannerResults = results.barcodes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print("Error scanning barcodes: \(error.localizedDescription)")
        }
    }
}

extension ScanBarcodesOnStillImagesViewController {
    
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

extension ScanBarcodesOnStillImagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodeScannerResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeResultCell")
            as? BarcodeResultTableViewCell {
            
            cell.barcodeImageView.image = try? self.barcodeScannerResults[indexPath.row].sourceImage?.toUIImage()
            cell.barcodeTextLabel.text = self.barcodeScannerResults[indexPath.row].textWithExtension
            cell.barcodeTypeLabel.text = self.barcodeScannerResults[indexPath.row].format.name
            
            return cell
        }
        return UITableViewCell()
    }
}

@available(iOS 14.0, *)
extension ScanBarcodesOnStillImagesViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                
                guard let image = image as? UIImage else {
                    return
                }
                self?.scanBarcode(on: image)
            }
        }
    }
}

// TODO: Remove in case we drop iOS 13.0
extension ScanBarcodesOnStillImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.scanBarcode(on: image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
