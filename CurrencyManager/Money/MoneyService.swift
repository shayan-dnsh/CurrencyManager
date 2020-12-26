//
//  MoneyService.swift
//  CurrencySample
//

//

import Foundation

protocol MoneyService {
    func getCurrentMoney() -> MoneyConfig?
    func getMoneyConfig(locale: String?) -> MoneyConfig?
}
