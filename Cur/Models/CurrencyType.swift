//
//  CurrencyType.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Foundation

enum CurrencyType: String {
    case RUB
    case USD
    case EUR
    case IDR
    case CNY
    case JPY
    case INR
    case HKD
    case GEL
    case CZK
    case AUD
    case TRY
}

extension CurrencyType: Equatable {

    var account: String {
        switch self {
            case .RUB:
                return "5008040510"
            case .USD:
                return "5228374848"
            case .EUR:
                return "5650040156"
            case .IDR:
                return "5645272955"
            case .CNY:
                return "5645350033"
            case .JPY:
                return "5648851326"
            case .INR:
                return "5648902087"
            case .HKD:
                return "5649236022"
            case .GEL:
                return "5649477956"
            case .CZK:
                return "5649601746"
            case .AUD:
                return "5649600417"
            case .TRY:
                return "5649601431"
        }
    }

    var priceFor1000USD: Float {
        switch self {
            case .RUB:
                return 102538
            case .USD:
                return 1000
            case .EUR:
                return 900
            case .IDR:
                return 144000000
            case .CNY:
                return 6300
            case .JPY:
                return 115000
            case .INR:
                return 75000 // Индийская рупия
            case .HKD:
                return 13000 // Гонконгский доллар
            case .GEL:
                return 3210 // Грузинский лари
            case .CZK:
                return 23000 // Чешская крона
            case .AUD:
                return 1000 // Австралийский доллар
            case .TRY:
                return 14000 // Турецкая лира
        }
    }
}
