//
//  Date+Helper.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 12/01/22.
//

import Foundation

extension Date {
    func getDateInFormate(of formateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formateString
        return dateFormatter.string(from: self)
    }
}
