//
//  CurrencyFetcher.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Foundation

struct CurrencyAPI {

    typealias CurrencyConvertResult = (
        fromAmount: Float,
        fromCuttency: CurrencyType,
        toAmount: Float,
        toCuttency: CurrencyType
    )

    let fetch: (
        _ amount: Float,
        _ currencyFrom: CurrencyType,
        _ currencyTo: CurrencyType,
        _ completion: @escaping (Result<ChangeResult, Error>) -> Void
    ) -> Void

    let fetchСourses: (
        _ currencyes: [CurrencyType],
        _ completion: @escaping (Result<[ChangeResult], Error>) -> Void
    ) -> Void
}

extension CurrencyAPI {

    enum CurrencyFetcherError: Error {
        case invalidURL
        case missingData
        case notAuth
    }

    static func newAPI(sessionID: String, userID: String) -> Self {

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)

        func fetch(
            amount: Float,
            currencyFrom: CurrencyType,
            currencyTo: CurrencyType,
            completion: @escaping (Result<ChangeResult, Error>) -> Void
        ) -> Void {

            guard !sessionID.isEmpty else {
                completion(.failure(CurrencyFetcherError.notAuth))
                return
            }

            guard let request = ChangeRequest.urlRequest(sessionID: sessionID, userID: userID, currencyFrom: currencyFrom, currencyTo: currencyTo, amount: amount) else {
                completion(.failure(CurrencyFetcherError.invalidURL))
                return
            }

            print(">> \(currencyFrom.rawValue) -> \(currencyTo.rawValue) START")

            session.dataTask(with: request) { data, _, error in

                print(">> \(currencyFrom.rawValue) -> \(currencyTo.rawValue) Done")
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(CurrencyFetcherError.missingData))
                    return
                }

                do {
                    let convertData = try JSONDecoder().decode(ConvertResultDTO.self, from: data)
                    guard
                        let payload = convertData.payload,
                        let fromC = CurrencyType(rawValue: payload.transactionAmount.currency.name),
                        let toC = CurrencyType(rawValue: payload.dstAmount.currency.name)
                    else {
                        completion(.failure(CurrencyFetcherError.notAuth))
                        print("request \(String(data: request.httpBody!, encoding: .utf8))")
                        return
                    }
                    let result = ChangeResult(
                        fromCount: payload.transactionAmount.value,
                        fromCurrency: fromC,
                        toCount: payload.dstAmount.value,
                        toCurrency: toC
                    )
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }

            }.resume()
        }

        func fetchСourses(currencyes: [CurrencyType], completion: @escaping (Result<[ChangeResult], Error>) -> Void ) -> Void {
            let dispatchGroup = DispatchGroup()
            var requestError: Error?
            var transactions: [ChangeResult] = []

            for fromC in currencyes {
                for toC in currencyes where toC != fromC {
                        dispatchGroup.enter()
                        usleep([10000, 50000].randomElement() ?? 0)
                        fetch(amount: fromC.priceFor1000USD, currencyFrom: fromC, currencyTo: toC) { result in
                            switch result {
                                case .success(let data):
                                    transactions.append(ChangeResult(
                                        fromCount: 1000,
                                        fromCurrency: data.fromCurrency,
                                        toCount: (data.toCount * 1000) / data.fromCount,
                                        toCurrency: data.toCurrency
                                    ))
                                case .failure(let error):
                                    requestError = error
                            }
                            dispatchGroup.leave()
                        }

                }
            }

            dispatchGroup.notify(queue: .main) {
                if let error = requestError {
                    completion(.failure(error))
                } else {
                    transactions.sort { $0.fromCurrency.rawValue < $1.fromCurrency.rawValue }
                    completion(.success(transactions))
                }
            }
        }

        return .init(
            fetch: fetch(amount:currencyFrom:currencyTo:completion:),
            fetchСourses: fetchСourses(currencyes:completion:)
        )
    }
}

extension Error {

    var isAuthError: Bool {
        if let loaderError = self as? CurrencyAPI.CurrencyFetcherError, loaderError == .notAuth {
            return true
        }
        return false
    }
}
