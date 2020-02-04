//
//  EditPhoneView.swift
//  UBAuthFlow
//
//  Created by Usemobile on 04/07/19.
//

import UIKit

import TPKeyboardAvoiding

protocol EditPhoneViewDelegate: class {
    func editPhoneView(_ view: EditPhoneView, didRequestResend phone: String)
}

class EditPhoneView: UIView {
    
    // MARK: - UI Components

    lazy var scrollView: TPKeyboardAvoidingScrollView = {
        let scrollView = TPKeyboardAvoidingScrollView()
        self.addSubview(scrollView)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        self.scrollView.addSubview(view)
        return view
    }()
    
    lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = self.settings.titleFont
        label.textColor = self.settings.titleColor
        label.textAlignment = .left
        label.text = .didntReceiveSMS
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var lblSubTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = self.settings.subTitleFont
        label.textColor = self.settings.subTitleColor
        label.textAlignment = .left
        label.text = .fillPhoneAgain
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var txfPhone: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.placeholder = .phone
        textField.setupPhone(language: self.settings.currentLanguage)
        if self.settings.currentLanguage == "es-BO"{
            textField.defaultText = self.phone
        }else{
            textField.defaultText = self.phone.westernArabicNumeralsOnly.formatted(textField.textMask)
        }
        
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.phone = text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            let _ = strongSelf.txfPhone.resignFirstResponder()
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var btnResend: SimpleButton = {
        let button = SimpleButton(settings: self.buttonSettings)
        button.spinnerColor = .white
        button.setTitle(.sendAgain, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.resendPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    // MARK: - Properties
    
    var settings: EditPhoneSettings
    var textFieldSettings: TextFieldSettings
    var buttonSettings: ButtonSettings
    var phone: String
    
    weak var delegate: EditPhoneViewDelegate?
    
    private var contentViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - LifeCycle
    
    init(settings: EditPhoneSettings,
         textFieldSettings: TextFieldSettings,
         buttonSettings: ButtonSettings,
         phone: String,
         currentLanguage: String) {
        self.settings = settings
        self.settings.currentLanguage = currentLanguage
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        self.phone = phone
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.textFieldSettings = .default
        self.buttonSettings = .default
        self.phone = ""
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentViewHeightConstraint.constant = -(self.getMargin())
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.backgroundColor = .white
        self.scrollView.fillSuperview()
        self.contentView.fillSuperview()
        self.contentViewHeightConstraint = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        self.contentViewHeightConstraint.isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        let buttonHeight: CGFloat = 54.dynamicCGFloat
        self.lblTitle.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: nil, right: self.contentView.rightAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        self.lblSubTitle.anchor(top: self.lblTitle.bottomAnchor, left: self.lblTitle.leftAnchor, bottom: nil, right: self.lblTitle.rightAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
        self.txfPhone.anchor(top: self.lblSubTitle.bottomAnchor, left: self.lblSubTitle.leftAnchor, bottom: nil, right: self.lblSubTitle.rightAnchor, padding: .init(top: 48, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
        self.btnResend.anchor(top: self.txfPhone.bottomAnchor, left: self.txfPhone.leftAnchor, bottom: nil, right: self.lblTitle.rightAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
    }
    
    private func checkButtonState() {
        self.btnResend.isEnabled = !self.phone.isEmpty
    }
    
    @objc func resendPressed(_ sender: SimpleButton) {
        self.endEditing(false)
        self.delegate?.editPhoneView(self, didRequestResend: self.phone)
    }
    
    public func playProgress() {
        self.btnResend.startAnimation()
    }
    
    public func stopProgress(animationStyle: StopAnimationStyle = .normal, revertAfterDelay: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        self.btnResend.stopAnimation(animationStyle: animationStyle, revertAfterDelay: revertAfterDelay, completion: completion)
    }
    
}
