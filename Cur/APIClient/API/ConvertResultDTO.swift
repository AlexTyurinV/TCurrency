//
//  ConvertDataDTO.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Foundation

struct CurrencyDTO: Decodable {
    let name: String
}

struct AmountDTO: Decodable {
    let currency: CurrencyDTO
    let value: Float
}

struct PayloadDTO: Decodable {
    let dstAmount: AmountDTO
    let transactionAmount: AmountDTO
}

struct ConvertResultDTO: Decodable {
    let payload: PayloadDTO?
    let resultCode: String
}
