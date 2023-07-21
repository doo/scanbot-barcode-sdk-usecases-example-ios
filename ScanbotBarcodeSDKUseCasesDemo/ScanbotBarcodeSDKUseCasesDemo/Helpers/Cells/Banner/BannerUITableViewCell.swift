//
//  BannerUITableViewCell.swift
//  ScanbotBarcodeSDKUseCasesDemo
//
//  Created by Rana Sohaib on 21.07.23.
//

import UIKit

class BannerUITableViewCell: UITableViewCell {
    
    @IBAction func contactSupportTapped(_ sender: UIButton) {
        if let url = URL(string: "https://scanbot.io/barcodedemo-contact-ios/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func getLicenseTapped(_ sender: UIButton) {
        if let url = URL(string: "https://scanbot.io/trial/poc/") {
            UIApplication.shared.open(url)
        }
    }
}
