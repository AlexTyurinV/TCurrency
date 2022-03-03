//
//  ChangeRequest.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Foundation

struct ChangeRequest {

    static func urlRequest(sessionID: String, userID: String, currencyFrom: CurrencyType, currencyTo: CurrencyType, amount: Float) -> URLRequest? {

        let urlStr = "https://www.tinkoff.ru/api/common/v1/get_held_payment_commission?sessionid=\(sessionID)&wuid=\(userID)"

        let body: [String: Any] = [
            "account": currencyFrom.account,
            "currency": currencyFrom.rawValue,
            "amount": String(format: "%.2f", amount),
            "srcCurrency": currencyFrom.rawValue,
            "dstCurrency": currencyTo.rawValue,
            "provider": "transfer-inner"
        ]

        guard let url = URL(string: urlStr) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.map({ "\($0.key)=\($0.value)" }).joined(separator: "&").data(using: .utf8)
        return request
    }
}
