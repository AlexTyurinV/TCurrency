//
//  BestWayCalculator.swift
//  Cur
//
//  Created by Alex Tyurin on 03.03.2022.
//

import Cocoa

class BestWayCalculator {

    private var bestWayFullCombinationsRUB_RUB: [[CurrencyType]] = []
    private var bestWayFullCombinationsUSD_USD: [[CurrencyType]] = []
    private var bestWayFullCombinationsEUR_EUR: [[CurrencyType]] = []

    let rateManager = RateManager()
    private let currencyes: [CurrencyType]

    init(currencyes: [CurrencyType]) {
        self.currencyes = currencyes
    }


    func start(completion: @escaping (Error?) -> Void) {
        refresh(completion: completion)
        startCommonWayCalculation()
    }

    func refresh(completion: @escaping (Error?) -> Void) {
        startRateManager(completion: completion)
    }

    func optimize(startAmount: Float, from: CurrencyType, to: CurrencyType) -> [Transaction] {
        let steps = steps(from: from, to: to)
        return steps.map { makeTransaction(startAmount: startAmount, road: $0) }.sorted { $0.toCount > $1.toCount }
    }

    private func makeTransaction(startAmount: Float, road: [CurrencyType]) -> Transaction {
        assert(road.count > 1, "road is too short")

        var steps: [ChangeResult] = []

        var currency: CurrencyType?
        var amount: Float = startAmount
        for newCur in road {
            guard let oldCur = currency else {
                currency = newCur
                continue
            }
            currency = newCur
            let oldAmoun = amount

            amount = rateManager.convertToValue(amount: amount, fromCurrency: oldCur, toCurrency: newCur)

            steps.append(ChangeResult(
                fromCount: oldAmoun,
                fromCurrency: oldCur,
                toCount: amount,
                toCurrency: newCur
            ))
        }

        return Transaction(
            fromCount: startAmount,
            fromCurrency: steps.first!.fromCurrency,
            toCount: steps.last?.toCount ?? 0,
            toCurrency: steps.last!.toCurrency,
            steps: steps
        )
    }
}

extension BestWayCalculator {

    private func startRateManager(completion: @escaping (Error?) -> Void) {
        rateManager.update(currencyes: currencyes, completion: completion)
    }

    private func startCommonWayCalculation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let RUB_RUB = self.currencyes.combination(prefix: .RUB, sufix: .RUB)
            DispatchQueue.main.async {
                self.bestWayFullCombinationsRUB_RUB = RUB_RUB
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let USD_USD = self.currencyes.combination(prefix: .USD, sufix: .USD)
            DispatchQueue.main.async {
                self.bestWayFullCombinationsUSD_USD = USD_USD
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let EUR_EUR = self.currencyes.combination(prefix: .EUR, sufix: .EUR)
            DispatchQueue.main.async {
                self.bestWayFullCombinationsEUR_EUR = EUR_EUR
            }
        }
    }

    private func steps(from: CurrencyType, to: CurrencyType) -> [[CurrencyType]] {
        let list: [[CurrencyType]]
        if from == .RUB && to == .RUB && !bestWayFullCombinationsRUB_RUB.isEmpty {
            list = bestWayFullCombinationsRUB_RUB
        } else if from == .EUR && to == .EUR && !bestWayFullCombinationsEUR_EUR.isEmpty {
            list = bestWayFullCombinationsEUR_EUR
        } else if from == .USD && to == .USD && !bestWayFullCombinationsUSD_USD.isEmpty {
            list = bestWayFullCombinationsUSD_USD
        } else {
            list = currencyes.combinationFast(prefix: from, sufix: to)
        }
        return list
    }
}
