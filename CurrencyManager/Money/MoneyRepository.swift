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
    
    func getMoneyConfig(locale: String?) -> MoneyConfig? {
        return moneyService.getMoneyConfig(locale: locale)
    }
}
