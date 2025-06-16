//
//  UseCasesListTableViewController.swift
//  Scanbot Barcode SDK
//
//  Created by Rana Sohaib on 12.07.23.
//

import UIKit

final class UseCasesListTableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
