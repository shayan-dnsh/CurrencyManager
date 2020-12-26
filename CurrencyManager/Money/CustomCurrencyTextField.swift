//
//  CustomTextField.swift
//  CurrencySample
//

import UIKit

class CustomCurrencyTextField: UITextField {
    
    enum TextFieldState {
        case normal
        case error
        case focus
    }
    
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    let moneyInputManager = MoneyInputManager(moneyRepository: MoneyRepository(moneyService: MoneyServiceProvider()))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        //        delegate = self
        
        self.autocorrectionType  = .no
        self.layer.cornerRadius  = 4
        self.layer.masksToBounds = true
        
        self.backgroundColor     = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        self.tintColor           = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.textColor           = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        
        self.keyboardType        = .numbersAndPunctuation
    }
    
}

extension CustomCurrencyTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        guard count < 10 else {
            return false
        }
        
        guard let textField = textField as? CustomCurrencyTextField else {
            return false
        }
        
        let string = string.toEnNumber
        
        var shouldReplacingChar = true
        
        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            
            textFieldText.enumerated().forEach({ (offset, element) in
                if offset == cursorPosition - 1 {
                    
                    if element == textField.moneyInputManager.currentMoneyConfig?.currency?.groupingSeperator?.first ?? "." {
                        textFieldText.remove(at: textFieldText.index(textFieldText.startIndex, offsetBy: offset))
                        textFieldText.remove(at: textFieldText.index(textFieldText.startIndex, offsetBy: offset - 1))
                        
                        shouldReplacingChar = false
                    }
                }
            })
            
        }
        
        guard var result = shouldReplacingChar ? (textFieldText as NSString?)?.replacingCharacters(in: range, with: string ) : textFieldText else {
            return false
            
        }
        
        if string == UIPasteboard.general.string {
            result = textField.moneyInputManager.filterPastedInput(value: result) ?? result
        }
        
        if result == "" {
            textField.text = ""
            return false
        }
        
        result = result.replacingOccurrences(of: textField.moneyInputManager.currentMoneyConfig?.currency?.groupingSeperator ?? "٬", with: "")
        let manipulatedString = textField.moneyInputManager.getValueWithGroupingPoint(value: result)
        
        if !textField.moneyInputManager.isValidInputNumber(value: manipulatedString ?? "") {
            return false
        }
        
        textField.text = manipulatedString
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        return true
    }
    
}



extension CustomCurrencyTextField {
    
    func performCurrency(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool? {
        guard var textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        guard count < 10 || string == UIPasteboard.general.string else {
            return false
        }
        
        guard let textField = textField as? CustomCurrencyTextField else {
            return false
        }
        
        let string = string.toEnNumber
        
        var shouldReplacingChar = true
        
        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            
            textFieldText.enumerated().forEach({ (offset, element) in
                if offset == cursorPosition - 1 {
                    
                    if element == textField.moneyInputManager.currentMoneyConfig?.currency?.groupingSeperator?.first ?? "." {
                        textFieldText.remove(at: textFieldText.index(textFieldText.startIndex, offsetBy: offset))
                        textFieldText.remove(at: textFieldText.index(textFieldText.startIndex, offsetBy: offset - 1))
                        
                        shouldReplacingChar = false
                    }
                }
            })
            
        }
        
        guard var result = shouldReplacingChar ? (textFieldText as NSString?)?.replacingCharacters(in: range, with: string ) : textFieldText else {
            return nil
            
        }
        
        if string == UIPasteboard.general.string {
            result = textField.moneyInputManager.filterPastedInput(value: result) ?? result
        }
        
        if result == "" {
            textField.text = ""
            return false
        }
        
        result = result.replacingOccurrences(of: textField.moneyInputManager.currentMoneyConfig?.currency?.groupingSeperator ?? "٬", with: "")
        let manipulatedString = textField.moneyInputManager.getValueWithGroupingPoint(value: result)
        
        if !textField.moneyInputManager.isValidInputNumber(value: manipulatedString ?? "") {
            return false
        }
        self.text = manipulatedString
        return false
    }
    
}
