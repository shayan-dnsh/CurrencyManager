//
//  MoneyInputManager.swift
//  CurrencySample
//
//

import Foundation


// Put this at file level anywhere in your project
precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

protocol MoneyValidator {
    func isValidInputNumber(value: String) -> Bool
    func getValueWithGroupingPoint(value: String?) -> String?
    func filterPastedInput(value: String?) -> String?
}

class MoneyInputManager: MoneyValidator {
    
    
    
    var moneyRepository: MoneyRepository
    
    var currentMoneyConfig: MoneyConfig?
    
    var locale: String
    
    init(moneyRepository: MoneyRepository, locale: String) {
        self.moneyRepository = moneyRepository
        self.locale = locale
        self.currentMoneyConfig = moneyRepository.getMoney(locale: locale)
    }
    
    // Validate input based on regex
    func isValidInputNumber(value: String) -> Bool {
        var tempValue = value
        
        if tempValue.last == currentMoneyConfig?.currency?.fractionSymbol?.last ?? "," {
            tempValue.removeLast()
        }
        
        let numberPred = NSPredicate(format: "SELF MATCHES %@", currentMoneyConfig?.regex ?? "")
        return numberPred.evaluate(with: tempValue)
        
    }
    
    func getValueWithGroupingPoint(value: String?) -> String? {
        guard var value = value else {
            return nil
        }
        value = checkExtraFractionNumber(value: value)
        
        value = value.replacingOccurrences(of: currentMoneyConfig?.currency?.fractionSymbol ?? ",", with: ".")
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle           = .decimal
        currencyFormatter.maximumFractionDigits = currentMoneyConfig?.currency?.fractionCount ?? 0
        currencyFormatter.groupingSeparator     = currentMoneyConfig?.currency?.groupingSeperator
        currencyFormatter.locale = Locale(identifier: locale)
        
        if let numberValue = Double(value) {
            var result = currencyFormatter.string(from: NSNumber(value: numberValue))?.toEnNumber
            result = checkFractionExistInLast(sourceString: value, targetString: result)
            return result
        }
        
        return value
    }
    
    // Append fraction if needed to end of number
    private func checkFractionExistInLast(sourceString: String, targetString: String?) -> String? {
        var tempTarget = targetString
        var isFractinExist = false
        
        sourceString.forEach { (char) in
            if sourceString.last == currentMoneyConfig?.currency?.groupingSeperator?.last , !isFractinExist {
                isFractinExist = true
                tempTarget?.append(currentMoneyConfig?.currency?.fractionSymbol ?? ",")
            }
        }
        
        return tempTarget
    }
    
    private func checkExtraFractionNumber(value: String) -> String {
        var tempValue = value
        let sections = tempValue.split(separator: currentMoneyConfig?.currency?.fractionSymbol?.last ?? ",")
        if sections.count == 2 {
            if sections[1].count > 2 {
                tempValue.removeLast()
                return tempValue
            }
        }
        return tempValue
    }
    
    func filterPastedInput(value: String?) -> String? {
        var regex = ""
        if currentMoneyConfig?.currency?.fractionSymbol != nil {
            regex = #"([0-9])*(,\d{1,2})?"#
        } else {
            regex = #"([1-9])*(\d{0})?"#
        }
        let matchList = matches(regex: regex, text: value ?? "")
        
        return matchList.first
    }
    
    private func matches(regex: String, text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            var tempResult = results.map { String(text[Range($0.range, in: text)!]) }
            tempResult = tempResult.filter({!$0.isEmpty})
            return tempResult
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func convertUnit(amount: String?) -> String {
        guard var value = amount else {
            return amount ?? ""
        }
        value = value.replacingOccurrences(of: currentMoneyConfig?.currency?.groupingSeperator ?? "٬", with: "")
        value = value.replacingOccurrences(of: currentMoneyConfig?.currency?.fractionSymbol ?? ",", with: ".")
        
        let fractionCount = currentMoneyConfig?.currency?.fractionCount ?? 0
        let multiplyValue = 10 ^^ fractionCount
        let result = Int((Double(value) ?? 0) * Double(multiplyValue))
        
        return String(result)
    }
    
    
}

extension String {
    var toEnNumber: String {
        let faNumbers = ["۰": "0","۱": "1","۲": "2","۳": "3","۴": "4","۵": "5","۶": "6","۷": "7","۸": "8","۹": "9"]
        var txt = self
        faNumbers.map {txt = txt.replacingOccurrences(of: $0, with: $1)}
        return txt
    }
    
    var toFANumber: String {
        let faNumbers = ["۰": "0","۱": "1","۲": "2","۳": "3","۴": "4","۵": "5","۶": "6","۷": "7","۸": "8","۹": "9"]
        var txt = self
        faNumbers.map {txt = txt.replacingOccurrences(of: $1, with: $0)}
        return txt
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

