//
//  MoneyService.swift
//  CurrencySample
//

//

import Foundation

protocol MoneyService {
    func getCurrentMoney() -> MoneyConfig?
    func getMoney(locale: String) -> MoneyConfig?
}
