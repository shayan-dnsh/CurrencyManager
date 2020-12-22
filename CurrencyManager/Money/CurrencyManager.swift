//
//  Currency.swift
//  CurrencySample
//
//

import Foundation

class CurrencyManager {
    
    var moneyInputManager: MoneyInputManager
    
    var currencyDictionary: [String: Any] = [
        "fa": [
            "fa" : "ریال",
            "en" : "IRR",
            "tr" : "Riyali"
        ],
        "tr": [
            "fa": "لیر",
            "en": "TRY",
            "tr": "TRY"
        ],
        "us": [
            "fa": "دلار",
            "en": "USD",
            "tr": "USD"
        ]
    ]
    
    static let shared: CurrencyManager = CurrencyManager()
    
    private init() {
        moneyInputManager = MoneyInputManager(moneyRepository: MoneyRepository(moneyService: MockMoneyService()), locale: "fa_IR")
    }
    
    private var cache: [String:String] = [:]
    
    func findSymbol(currencyCode:String) -> String {
        if let hit = cache[currencyCode] { return hit }
        guard currencyCode.count < 4 else { return "" }
        
        let symbol = findSymbolBy(currencyCode)
        cache[currencyCode] = symbol
        
        return symbol
    }
    
    private func findSymbolBy(_ currencyCode: String) -> String {
        var candidates: [String] = []
        let locales = NSLocale.availableLocaleIdentifiers
        
        for localeId in locales {
            guard let symbol = findSymbolBy(localeId, currencyCode) else { continue }
            if symbol.count == 1 { return symbol }
            candidates.append(symbol)
        }
        
        return candidates.sorted(by: { $0.count < $1.count }).first ?? ""
    }
    
    private func findSymbolBy(_ localeId: String, _ currencyCode: String) -> String? {
        let locale = Locale(identifier: localeId)
        return currencyCode.caseInsensitiveCompare(locale.currencyCode ?? "") == .orderedSame
            ? locale.currencySymbol : nil
    }
    
    @objc func formatAmount(amount: NSNumber?) -> String {
        
        guard let amount = amount else {
            return ""
        }
        
        var amountString = amount.stringValue
        var valueSign: Character?
        
        if amount.stringValue.first == "+" {
            valueSign = amount.stringValue.first
            amountString = amount.stringValue.replacingOccurrences(of: "+", with: "")
            
        } else if amount.stringValue.first == "-" {
            valueSign = amount.stringValue.first
            amountString = amount.stringValue.replacingOccurrences(of: "-", with: "")
        }
        
        let manipulatedAmount = moneyInputManager.getValueWithGroupingPoint(value: amountString)
        
        if !moneyInputManager.isValidInputNumber(value: manipulatedAmount ?? "") {
            return ""
        }
        
        return "\(valueSign != nil ? String(valueSign!) : "")\(manipulatedAmount ?? "")"
    }
    
    @objc func formatAmount(amountString: String?) -> String {
        
        guard var amountString = amountString else {
            return ""
        }
    
        var valueSign: Character?
        
        if amountString.first == "+" {
            valueSign = amountString.first
            amountString = amountString.replacingOccurrences(of: "+", with: "")
            
        } else if amountString.first == "-" {
            valueSign = amountString.first
            amountString = amountString.replacingOccurrences(of: "-", with: "")
        }
        
        let manipulatedAmount = moneyInputManager.getValueWithGroupingPoint(value: amountString)
        
        if !moneyInputManager.isValidInputNumber(value: manipulatedAmount ?? "") {
            return ""
        }
        
        return "\(valueSign != nil ? String(valueSign!) : "")\(manipulatedAmount ?? "")"
    }
    
    func getCurrency(locale: String, lang: String) -> String? {
        let langDic = currencyDictionary[locale] as? [String: Any]
        let result = langDic?[lang] as? String
        return result ?? ""
    }
    
    func getCurrency() -> String?{
        let currentLocaleIdentifier = Locale.current.identifier
        let currentLang = "fa"
        let langDic = currencyDictionary[currentLocaleIdentifier] as? [String: Any]
        let result = langDic?[currentLang] as? String
        return result ?? ""
    }
}

