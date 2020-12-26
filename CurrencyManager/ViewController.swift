//
//  ViewController.swift
//  CurrencyManager
//
//  Created by Developer on 10/2/1399 AP.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var actualInputLabel: UILabel!
    
    @IBOutlet weak var moneyInputView: MoneyInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moneyInputView.moneyInputViewDelegate = self
    }


}

extension ViewController: MoneyInputViewProtocol {
    func customTextFieldChanged() {
        let textField = moneyInputView.moneyTextField
        actualInputLabel.text = textField?.moneyInputManager.convertUnit(amount: textField?.text)
    }
    
    
}
