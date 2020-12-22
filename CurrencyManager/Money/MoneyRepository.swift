//
//  MoneyRepository.swift
//  CurrencySample
//

//

import Foundation

struct MoneyRepository {
    
    let moneyService: MoneyService
    
    init(moneyService: MoneyService) {
        self.moneyService = moneyService
    }
    
    func getCurrentMoney() -> MoneyConfig? {
        return moneyService.getCurrentMoney()
    }
    
    func getMoney(locale: String) -> MoneyConfig? {
        return moneyService.getMoney(locale: locale)
    }
}
