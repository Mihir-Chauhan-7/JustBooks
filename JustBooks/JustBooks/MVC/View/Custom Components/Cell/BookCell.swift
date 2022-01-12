//
//  BookCell.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 10/01/22.
//

import UIKit

protocol BookDelegate {
    func btnPurchaseClicked(indexPath: IndexPath)
    func btnExpandClicked(indexPath: IndexPath)
}

class BookCell: UITableViewCell {
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblAuthor: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblSynopsis: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var btnExpand: UIButton!
    @IBOutlet private weak var btnPurchase: UIButton!
    @IBOutlet private weak var expandableView: UIStackView!
    @IBOutlet private weak var imgPurchased: UIImageView!
    
    var indexPath: IndexPath!
    var delegate: BookDelegate?
    
    var book: BookCDM! {
        didSet {
            self.lblTitle.text = "Book Name : \(book.name ?? "")"
            self.lblPrice.text = "Price : $\(book.price ?? 0)"
            self.lblAuthor.text = "Author : \(book.author ?? "")"
            self.lblSynopsis.text = self.book.synopsis
            self.lblDescription.text = self.expandableView.isHidden ? "" : "Description : \((book.bDescription ?? ""))"
            self.contentView.addTapGesture(target: self, action: #selector(bookCellTapped))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.btnPurchase.layer.cornerRadius = self.btnPurchase.bounds.height / 2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPurchased(_ isPurchased: Bool) {
        self.btnPurchase.isHidden = isPurchased
        self.imgPurchased.isHidden = !isPurchased
        self.btnPurchase.isSelected = isPurchased
        self.btnPurchase.isUserInteractionEnabled = !isPurchased
    }
    
    @objc private func bookCellTapped() {
        self.delegate?.btnExpandClicked(indexPath: self.indexPath)
    }
    
    @IBAction private func btnPurchaseClicked(_ sender: UIButton) {
        self.delegate?.btnPurchaseClicked(indexPath: indexPath)
    }
    
    @IBAction private func btnExpandClicked(_ sender: UIButton) {
        self.delegate?.btnExpandClicked(indexPath: indexPath)
    }
    
    func setDescription(isExpanded: Bool) {
        self.expandableView.isHidden = isExpanded
        self.btnExpand.isSelected = !isExpanded
    }
}
