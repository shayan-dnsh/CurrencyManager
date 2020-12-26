//
//  Currency.swift
//  CurrencySample
//
//

import Foundation
import UIKit

class CurrencyHelpHandler {
    
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
    
    static let shared: CurrencyHelpHandler = CurrencyHelpHandler()
    
    private init() {
        moneyInputManager = MoneyInputManager(moneyRepository: MoneyRepository(moneyService: MoneyServiceProvider()))
    }
    
    private var cache: [String:String] = [:]
    
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
    
    @objc func convertToUnit(amount: String?) -> String {
        guard var value = amount else {
            return amount ?? ""
        }
        let currentMoneyConfig = moneyInputManager.currentMoneyConfig
        value = value.replacingOccurrences(of: currentMoneyConfig?.currency?.groupingSeperator ?? ",", with: "")
        
        if let symbole = currentMoneyConfig?.currency?.fractionSymbol {
            value = value.replacingOccurrences(of: symbole, with: ".")
        }
        
        let fractionCount = currentMoneyConfig?.currency?.fractionCount ?? 0
        let multiplyValue = 10 ^^ fractionCount
        let result = UInt64((Double(value) ?? 0) * Double(multiplyValue))
        
        return String(result)
    }
    
    @objc func convertFromUnit(amount: NSNumber?) -> NSNumber? {
        guard let value = amount else {
            return amount ?? 0
        }
        
        let currentMoneyConfig = moneyInputManager.currentMoneyConfig
        let fractionCount = currentMoneyConfig?.currency?.fractionCount ?? 0
        
        let multiplyValue = CGFloat(1) / CGFloat((10 ^^ fractionCount))
        let result = Double(truncating: value) * Double(multiplyValue)
        
        return NSNumber(value: result)
    }
    
    @objc func getAmountWithCurrencySymbol(value: NSNumber?, lang: String, locale: String) -> String? {
        guard let value = value else {
            return ""
        }
        let amount = convertFromUnit(amount: value) ?? 0
        let result = formatAmountWithsymbole(amountString: "\(amount)", lang: lang, locale: locale)
        return "\(result)"
    }
    
   
    
    @objc func formatAmount(amount: NSNumber?, lang: String = "en", locale: String) -> String {
        
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
        
        return "\(valueSign != nil ? String(valueSign!) : "")\(manipulatedAmount ?? "") \(getCurrency(locale: locale, lang: lang))"
    }
    
    @objc func formatAmount(amountString: String?,
                            lang: String, locale: String) -> String {
        
        let currency = getCurrency(locale: locale, lang: lang)
        return "\(formatOnlyAmount(amountString: amountString)) \(currency)"
    }
    
    @objc func formatAmountWithsymbole(amountString: String?,
                                       lang: String, locale: String) -> String {
        
        let currency = findSymbolBy(moneyInputManager.currentMoneyConfig?.currency?.isoCode ?? "")
        return "\(formatOnlyAmount(amountString: amountString)) \(currency)"
    }
    
    @objc func formatOnlyAmount(amountString: String?) -> String {
        guard amountString != nil else {
            return ""
        }
        
        var amString = amountString ?? ""

        var valueSign: Character?
        
        if amString.first == "+" {
            valueSign = amString.first
            amString = amString.replacingOccurrences(of: "+", with: "")
            
        } else if amString.first == "-" {
            valueSign = amString.first
            amString = amString.replacingOccurrences(of: "-", with: "")
        }
        
        let manipulatedAmount = moneyInputManager.getValueWithGroupingPoint(value: amString)
        
        if !moneyInputManager.isValidInputNumber(value: manipulatedAmount ?? "") {
            return ""
        }
                
        return "\(valueSign != nil ? String(valueSign!) : "")\(manipulatedAmount ?? "")"
    }
    
    @objc func convertToPureValue(amount: String?) -> NSNumber {
        guard amount != nil else {
            return 0
        }
        guard let groupingSeperator = moneyInputManager.currentMoneyConfig?.currency?.groupingSeperator else {
            return NSNumber(value: Double(amount!) ?? 0)
        }
        var result = ""
        result = amount?.replacingOccurrences(of: groupingSeperator, with: "") ?? ""
        
        if let fractionSymbol = moneyInputManager.currentMoneyConfig?.currency?.fractionSymbol {
            result = result.replacingOccurrences(of: fractionSymbol, with: ".")
        }
        
        return NSNumber(value: Double(result) ?? 0)
    }
    
    @objc func formatWebEngageAmount(amount: String?) -> NSNumber {
        guard amount != nil else {
            return 0
        }
        guard let groupingSeperator = moneyInputManager.currentMoneyConfig?.currency?.groupingSeperator else {
            return NSNumber(pointer: amount!)
        }
        var result = ""
        result = amount?.replacingOccurrences(of: groupingSeperator, with: "") ?? ""
        
        if let fractionSymbol = moneyInputManager.currentMoneyConfig?.currency?.fractionSymbol {
            result = result.replacingOccurrences(of: fractionSymbol, with: ".")
        }
        
        return NSNumber(pointer: result)
    }
    
    @objc func getCurrencyISO() -> String {
        return moneyInputManager.currentMoneyConfig?.currency?.isoCode ?? ""
    }
    
    func findSymbol(currencyISOCode: String) -> String {
        if let hit = cache[currencyISOCode] { return hit }
        guard currencyISOCode.count < 4 else { return "" }
        
        let symbol = findSymbolBy(currencyISOCode)
        cache[currencyISOCode] = symbol
        
        return symbol
    }
    
    private func findSymbolBy(_ currencyISOCode: String) -> String {
        var candidates: [String] = []
        let locales = NSLocale.availableLocaleIdentifiers
        
        for localeId in locales {
            guard let symbol = findSymbolBy(localeId, currencyISOCode) else { continue }
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
    
}

