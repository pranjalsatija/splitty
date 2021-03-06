//
//  CurrencyFormatter.swift
//  splitty
//
//  Created by Pranjal Satija on 8/26/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

// MARK: Base Class
struct CurrencyFormatter {
    static var currencySymbol: String {
        return numberFormatter.currencySymbol ?? "$"
    }

    static private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
}

// MARK: Formatting
extension CurrencyFormatter {
    static func number(from string: String) -> NSNumber? {
        return numberFormatter.number(from: string)
    }

    static func reformat(_ string: String) -> String {
        guard let number = numberFormatter.number(from: string) else {
            return string
        }

        return numberFormatter.string(from: number) ?? string
    }

    static func string(from number: NSNumber) -> String {
        return numberFormatter.string(from: number) ?? number.stringValue
    }
}
