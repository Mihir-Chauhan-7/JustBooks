//
//  PurchaseCell.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 10/01/22.
//

import UIKit

protocol PurchaseDelegate {
    func deletePurchase(indexPath: IndexPath)
}

class PurchasedCell: UITableViewCell {
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblAuthor: UILabel!
    @IBOutlet private weak var lblSynopsis: UILabel!
    @IBOutlet private weak var lblPurchaseDate: UILabel!
    @IBOutlet private weak var btnDelete: UIButton!
    
    var indexPath: IndexPath!
    var delegate: PurchaseDelegate?
    
    var itemData: PurchaseCDM! {
        didSet {
            self.lblTitle.text = "Book Name : \(itemData.book?.name ?? "")"
            self.lblPrice.text = "Price : $\(itemData.book?.price ?? 0)"
            self.lblAuthor.text = "Author : \(itemData.book?.author ?? "")"
            self.lblSynopsis.text = " \(itemData.book?.synopsis ?? "")" 
            self.lblPurchaseDate.text = "Purchase Date : \((itemData.date ?? Date()).getDateInFormate(of: "d MMM, yyyy"))"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.btnDelete.layer.cornerRadius = self.btnDelete.frame.height / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction private func btnDeletePurchase(_ sender: UIButton) {
        delegate?.deletePurchase(indexPath: indexPath)
    }
}
