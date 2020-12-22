//
//  MoneyInputView.swift
//  CurrencySample
//

import UIKit

@available(iOS 9.0, *)
class MoneyInputView: UIView {
    
    @IBOutlet weak var moneyTextField: CustomTextField!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func setupView(){
        moneyTextField.delegate = self
    }
    
    private func loadView() {
        let view = UINib.loadMoneyInputView(withOwner: self)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.semanticContentAttribute = .forceLeftToRight
        addSubview(view)
        moneyTextField.clearButtonMode = .whileEditing
    }
    
}


extension UINib {
    
    class func loadMoneyInputView(withOwner owner: AnyObject) -> UIView {
        return loadSingleView("MoneyInputView", owner: owner)
    }
}

// MARK: UINib
private extension UINib {
    
    static func nib(named nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static func loadSingleView(_ nibName: String, owner: Any?) -> UIView {
        return nib(named: nibName).instantiate(withOwner: owner, options: nil)[0] as! UIView
    }
    
}


@available(iOS 9.0, *)
extension MoneyInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? CustomTextField else {
            return false
        }
        textField.performCurrency(textField, shouldChangeCharactersIn: range, replacementString: string)
        return false
    }
}
