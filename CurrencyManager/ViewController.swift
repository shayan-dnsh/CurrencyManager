//
//  ViewController.swift
//  CurrencyManager
//
//  Created by Developer on 10/2/1399 AP.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var moneyInputView: MoneyInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func transferMoney(_ sender: Any) {
        print(moneyInputView.moneyTextField.moneyInputManager.convertUnit(amount: moneyInputView.moneyTextField.text))
        moneyLabel.text = moneyInputView.moneyTextField.moneyInputManager.convertUnit(amount: moneyInputView.moneyTextField.text)
    }

}

