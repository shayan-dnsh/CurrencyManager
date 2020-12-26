//
//  MoneyServiceProvider.swift
//  CurrencySample
//

import Foundation


class MoneyServiceProvider: MoneyService {
    
    init() {}
    
    let turkeyMoney = MoneyConfig(locale: "tr_TR", language: "tr", country: "TR", currency: Currency(isoCode: "TRY", decimalSeperator: ",", groupingSeperator: ".", fractionCount: 2, fractionSymbol: ","), regex: #"(^[0-9]\d{0,2}(\.\d{3})*(,\d{1,2})?$)*"#)
    
    let iranMoney = MoneyConfig(locale: "fa_IR", language: "fa", country: "IR", currency: Currency(isoCode: "IRR", decimalSeperator: nil, groupingSeperator: ",", fractionCount: 0, fractionSymbol: nil), regex: #"(^[1-9]\d{0,2}(\,\d{3})*(,\d{0})?$)*"#)
    
    lazy var moneyList = [iranMoney, turkeyMoney]
    
    func getCurrentMoney() -> MoneyConfig? {
        let locale = Locale.current.identifier
        return moneyList.first(where: {$0.locale == locale})
    }
    
    func getMoneyConfig(locale: String?) -> MoneyConfig? {
        if locale != nil {
            return moneyList.first(where: {$0.locale == locale})
        } else {
            let currentLocale = Locale.current.identifier
            return moneyList.first(where: {$0.locale == currentLocale})
        }
        
    }
    
    
}
