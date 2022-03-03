//
//  RateManager.swift
//  Cur
//
//  Created by Alex Tyurin on 03.03.2022.
//

import Foundation

class RateManager {

    private var exchangeRates: [ChangeResult] = []

    func update(currencyes: [CurrencyType], completion: @escaping (Error?) -> Void) {
        let apiManager = CurrencyAPI.newAPI(
            sessionID: Session.live.sessionID(),
            userID: Session.live.userID()
        )
        apiManager.fetchСourses(currencyes, { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        self?.exchangeRates = data
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                }
            }
        })
    }

    func convertToValue(amount: Float, fromCurrency: CurrencyType, toCurrency: CurrencyType) -> Float {
        guard let exchange = exchangeRates.first(where: { $0.fromCurrency == fromCurrency && $0.toCurrency == toCurrency }) else {
            return 0
        }
        return (exchange.toCount * amount) / exchange.fromCount
    }
}
