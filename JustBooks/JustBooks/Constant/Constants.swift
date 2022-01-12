//
//  Constants.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 11/01/22.
//

import Foundation

struct AlertMessages {
    
    static let bookAdded = "Book Added."
    static let bookDeleted = "Book Deleted."
    static let bookPurchased = "Book Purchased."
    
    static let errorDeletingBook = "Error Deleting Book."
    static let errorSavingBook = "Error Saving Book."
    static let errorPurchasingBook =  "Error Purchasing Book."
    static let errorFetchingBook = "Error Fetching Book."
    static let errorFetchingPurchasedBook = "Error Fetching Purchased Book."
    
    static let bookNameEmpty = "Book name cannot be empty."
    static let bookAuthorNameEmpty = "Book author name cannot be empty."
    static let bookPriceEmpty = "Book price cannot be empty."
    static let bookSynopsisEmpty = "Book synopsis cannot be empty."
    static let bookSynopsisLimit = "Synopsis cannot be more than 10 words."
    static let bookDescriptionEmpty = "Description cannot be empty."
    static let bookDescriptionLimit = "Description cannot be more than 300 words."
    
}

extension Notification.Name {
    
    static let purchased_book = Notification.Name("purchased_book")
    static let added_new_book = Notification.Name("added_new_book")
    static let deleted_purchased_book = Notification.Name("deleted_purchased_book")
    
}
