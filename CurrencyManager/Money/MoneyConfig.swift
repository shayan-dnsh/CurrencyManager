//
//  Money.swift
//  CurrencySample
//
//

import Foundation

struct MoneyConfig: Codable {
    var locale: String?
    var language: String?
    var country: String?
    var currency: Currency?
    var regex: String?
}

struct Currency: Codable {
    var isoCode: String?
    var decimalSeperator: String?
    var groupingSeperator: String?
    var fractionCount: Int?
    var fractionSymbol: String?
}
