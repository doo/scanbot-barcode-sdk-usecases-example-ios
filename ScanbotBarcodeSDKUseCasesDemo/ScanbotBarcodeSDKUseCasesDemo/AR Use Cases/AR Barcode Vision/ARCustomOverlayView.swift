//
//  ARCustomOverlayView.swift
//  ScanbotBarcodeSDKUseCasesDemo
//
//  Created by Rana Sohaib on 10.08.23.
//

import UIKit
import ScanbotBarcodeScannerSDK

class ARCustomOverlayView: UIView {
    
    @IBOutlet private var detailContainerView: UIView!
    @IBOutlet private var detailImageView: UIImageView!
    @IBOutlet private var detailLabel: UILabel!
    
    // To store detected barcode
    var barcode: SBSDKBarcodeScannerResult!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailContainerView.layer.cornerRadius = 8.0
    }
    
    @IBAction private func openItemButtonTapped(_ sender: UIButton) {
        
        // Open product detail
    }
}

extension ARCustomOverlayView: SBSDKTrackedBarcodeInfoViewable {
    
    // Delegate method to provide the instance of the custom view
    static func make(withBarcode: SBSDKBarcodeScannerResult) -> SBSDKTrackedBarcodeInfoView {
        
        // Create custom view instance and return it
        let view = UINib(nibName: "ARCustomOverlayView", bundle: nil)
            .instantiate(withOwner: nil).first as! ARCustomOverlayView
        view.barcode = withBarcode
        
        return view
    }
    
    // Delegate method to updates the frame of the tracking view to match the position and size of the associated barcode
    func update(barcodeFrame: CGRect, isSelected: Bool,
                textStyle: SBSDKBarcodeTrackedViewTextStyle,
                polygonStyle: SBSDKBarcodeTrackedViewPolygonStyle) {
        
        // Disable the AR polygon tracking overlay as we only want to show our custom view
        // If you keep this property enabled then both (polygon and custom) tracking overlays will be drawn
        polygonStyle.polygonDrawingEnabled = false
        
        // Update the frames
        self.frame.size = CGSize(width: 180, height: 180)
        self.center = CGPoint(x: barcodeFrame.midX, y: barcodeFrame.midY)
        
        // Only show the custom view if barcode frame is bigger than a certain size
        if barcodeFrame.size.width * barcodeFrame.size.height > 100 * 100 {
            
            detailContainerView.isHidden = false
            detailLabel.text = barcode.rawTextStringWithExtension
            
            if barcode.rawTextString.last == "2" {
                detailImageView.image = UIImage(imageLiteralResourceName: "chocolate")
                
            } else if barcode.rawTextString.last == "4" {
                detailImageView.image = UIImage(imageLiteralResourceName: "coffee")
                
            } else if barcode.rawTextString.last == "6" {
                detailImageView.image = UIImage(imageLiteralResourceName: "apple_sauce")
                
            } else if barcode.rawTextString.last == "8" {
                detailImageView.image = UIImage(imageLiteralResourceName: "tea")
                
            }
            
        } else {
            
            detailContainerView.isHidden = true
        }
    }
}
