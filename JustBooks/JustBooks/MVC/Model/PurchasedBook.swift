//
//  PurchasedBook.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 11/01/22.
//

import Foundation

class PurchasedBook {
    
    var pId: UUID
    var date: Date
    var book: BookCDM
    var purchaseCDM: PurchaseCDM!
    
    init(pId: UUID, book: BookCDM, date: Date) {
        self.pId = pId
        self.book = book
        self.date = date
    }
    
    func updateCDM() {
        self.purchaseCDM.date = self.date
        self.purchaseCDM.book = self.book
    }
    
    func getPurchasedBookCDM() -> PurchaseCDM {
        
        if self.purchaseCDM != nil {
            return self.purchaseCDM
        }
        
        let purchasedBook = PurchaseCDM(context: AppDelegate.shared.persistentContainer.viewContext)
        purchasedBook.pId = self.pId
        purchasedBook.date = self.date
        purchasedBook.book = self.book
        self.purchaseCDM = purchasedBook
        return purchasedBook
    }
    
}
