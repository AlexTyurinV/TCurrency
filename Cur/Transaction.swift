//
//  Transaction.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Cocoa

struct Transaction {

    let fromCount: Float
    let fromCurrency: CurrencyType
    let toCount: Float
    let toCurrency: CurrencyType

    let steps: [ChangeResult]
}

extension Transaction: CustomStringConvertible {

    var hasProfit: Bool {
        fromCount < toCount && fromCurrency == toCurrency
    }

    var description: String {
        var line: String = ""
        for item in steps {
            if line.isEmpty {
                line += "\(item.fromCount) \(item.fromCurrency.rawValue) → "
            } else {
                line += " → "
            }
            line += "\(item.toCount) \(item.toCurrency.rawValue)"
        }
        if hasProfit {
            line = "🟢 \(line)"
        }
        return line
    }
}
