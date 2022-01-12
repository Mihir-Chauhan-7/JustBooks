//
//  Book.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 11/01/22.
//

import Foundation


class Book {
    
    var bId: UUID
    var name: String
    var author: String
    var price: Int32
    var quantity: Int32
    var synopsis: String
    var bDescription: String
    var bookCDM: BookCDM!
        
    init(bId: UUID, name: String, author: String, price: Int32, quantity: Int32, synopsis: String, bDescription: String) {
        self.bId = bId
        self.name = name
        self.author = author
        self.price = price
        self.quantity = quantity
        self.synopsis = synopsis
        self.bDescription = bDescription
    }
    
    func updateCDM() {
        self.bookCDM.name = self.name
        self.bookCDM.author = self.author
        self.bookCDM.price = NSNumber(value: self.price)
        self.bookCDM.quantity = NSNumber(value: self.quantity)
        self.bookCDM.synopsis = self.synopsis
        self.bookCDM.bDescription = self.bDescription
    }
    
    func getBookCDM() -> BookCDM {
        
        if self.bookCDM != nil {
            return self.bookCDM
        }
        
        let book = BookCDM(context: AppDelegate.shared.persistentContainer.viewContext)
        book.bId = self.bId
        book.name = self.name
        book.author = self.author
        book.price = NSNumber(value: self.price)
        book.quantity = NSNumber(value: self.quantity)
        book.synopsis = self.synopsis
        book.bDescription = self.bDescription
        self.bookCDM = book
        return book
    }
}
