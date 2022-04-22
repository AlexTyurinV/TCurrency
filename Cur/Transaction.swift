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

    let isIncreased: Bool?
}

extension Transaction: CustomStringConvertible {

    var hasProfit: Bool {
        fromCount < toCount && fromCurrency == toCurrency
    }

    var description: String {
        var line: String = ""
        for item in steps {
            if line.isEmpty {
                line += "\(item.fromCount.round2) \(item.fromCurrency.rawValue) → "
            } else {
                line += " → "
            }
            line += "\(item.toCount.round2) \(item.toCurrency.rawValue)"
        }
        if hasProfit {
            line = "🟢 \(line)"
        }
        if let isGrow = isIncreased {
            let leter = isGrow ? "⬆️" : "⬇️"
            line = "\(line) \(leter)"
        }
        return line
    }
}

extension Transaction: Hashable, Equatable {
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(fromCount)
        hasher.combine(fromCurrency)
        hasher.combine(toCurrency)

        steps.forEach {
            hasher.combine($0.fromCurrency)
            hasher.combine($0.toCurrency)
        }
    }
}

private extension Float {

    var round2: Float {
        self
        //round(100 * self) / 100
    }
}
