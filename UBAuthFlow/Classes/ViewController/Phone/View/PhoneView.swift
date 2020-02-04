//
//  PhoneView.swift
//  UBAuthFlow
//
//  Created by Usemobile on 28/05/19.
//

import UIKit

import TPKeyboardAvoiding

protocol PhoneViewDelegate: class {
    func phoneViewDidRequestChangePhone(_ view: PhoneView)
    func phoneViewDidRequestResendCode(_ view: PhoneView)
    func phoneView(_ view: PhoneView, didRequestPhoneValidationFor code: String)
}

class PhoneView: UIView {
    
    // MARK: - UI Components
    
    lazy var scrollView: TPKeyboardAvoidingScrollView = {
        let scrollView = TPKeyboardAvoidingScrollView()
        scrollView.backgroundColor = .clear
        self.addSubview(scrollView)
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        self.scrollView.addSubview(view)
        return view
    }()
    
    lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: .confirmNumber,
                                                       attributes: [NSAttributedString.Key.font: self.settings.titlePrefixFont, NSAttributedString.Key.foregroundColor: self.settings.titleColor])
        attributedText.append(NSAttributedString(string: .phone,
                                                 attributes: [NSAttributedString.Key.font: self.settings.titleSufixFont, NSAttributedString.Key.foregroundColor: self.settings.titleColor]))
        label.attributedText = attributedText
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var lblText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = self.settings.textFont
        label.textColor = self.settings.textColor
        label.text = .fillYourPhone
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var lblPhone: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = self.settings.phoneFont
        label.textColor = self.settings.phoneColor
        var formattedPhone = self.phone.westernArabicNumeralsOnly.formatted("")
        if self.settings.currentLanguage == "es-BO"{
            formattedPhone = self.phone.westernArabicNumeralsOnly.formatted("########")
        }else{
            formattedPhone = self.phone.westernArabicNumeralsOnly.formatted("(##) #####-####")
        }
//        let formattedPhone = self.phone.westernArabicNumeralsOnly.formatted("(##) #####-####")
        label.text = formattedPhone
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var btnEditPhone: UIButton = {
        let button = UIButton(type: .system)
        let image: UIImage? = self.settings.editImage ?? UIImage.getFrom(customClass: PhoneView.self, nameResource: "edit-phone")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = self.settings.editTintColor
        let insets: CGFloat = 12
        button.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        button.addTarget(self, action: #selector(self.btnEditPhonePressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    lazy var pinInputView: PinTextInputView = {
        let view = PinTextInputView()
        view.delegate = self
        view.textColor = self.settings.codeTextColor
        view.borderColor = self.settings.codeTintColor
        view.font = self.settings.codeFont
        if #available(iOS 12.0, *) {
            view.textContentType = .oneTimeCode
        }
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var btnResendCode: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(string: .resendCode,
                                                 attributes: [NSAttributedString.Key.font: self.settings.resendFont,
                                                              NSAttributedString.Key.foregroundColor: self.settings.resendColor,
                                                              NSAttributedString.Key.underlineStyle: 1])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(self.btnResendCodePressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    lazy var lblResendCode: UILabel = {
        let label = UILabel()
        label.text = .resendMessage + "0:" + String(format: "%02d", self.resendCodeCounterValue) + .seconds
        label.font = self.settings.timeFont
        label.textColor = self.settings.timeColor
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.isHidden = true
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var btnConfirm: SimpleButton = {
        let button = SimpleButton(settings: self.buttonSettings)
        button.spinnerColor = .white
        button.setTitle(.confirm, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.btnConfirmPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()

    var settings: PhoneSettings
    var buttonSettings: ButtonSettings
    var code: String = ""
    weak var delegate: PhoneViewDelegate?
    
    private var contentViewHeightConstraint = NSLayoutConstraint()
    private let resendCodeCounterValue = 30
    private var resendCodeCount = 30 {
        didSet {
            self.lblResendCode.text = .resendMessage + "0:" + String(format: "%02d", self.resendCodeCount) + .seconds
        }
    }
    var timer = Timer()
    var isResendBtnHidden = false
    
    var phone: String = ""
    
    init(settings: PhoneSettings, buttonSettings: ButtonSettings, phone: String, currentLanguage: String) {
        self.settings = settings
        self.settings.currentLanguage = currentLanguage
        self.buttonSettings = buttonSettings
        self.phone = phone
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.buttonSettings = .default
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentViewHeightConstraint.constant = -(self.getMargin())
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.scrollView.fillSuperview()
        self.contentView.fillSuperview()
        self.contentViewHeightConstraint = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        self.contentViewHeightConstraint.isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        self.lblTitle.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: nil, right: self.contentView.rightAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        self.lblText.anchor(top: self.lblTitle.bottomAnchor, left: self.lblTitle.leftAnchor, bottom: nil, right: self.lblTitle.rightAnchor, padding: .init(top: 18, left: 0, bottom: 0, right: 0))
        self.lblPhone.anchor(top: self.lblText.bottomAnchor, left: self.lblText.leftAnchor, bottom: nil, right: nil, padding: .init(top: 18, left: 0, bottom: 0, right: 0))
        
        let buttonSize: CGFloat = 44
        self.btnEditPhone.anchor(top: nil, left: self.lblPhone.rightAnchor, bottom: nil, right: nil, size: .init(width: buttonSize, height: buttonSize))
        self.btnEditPhone.centerYAnchor.constraint(equalTo: self.lblPhone.centerYAnchor).isActive = true
        
        self.pinInputView.anchor(top: self.lblPhone.bottomAnchor, left: nil, bottom: nil, right: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 270, height: 60))
        self.pinInputView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.lblResendCode.anchor(top: self.pinInputView.bottomAnchor, left: self.contentView.leftAnchor, bottom: nil, right: self.contentView.rightAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        self.btnResendCode.anchor(top: nil, left: nil, bottom: nil, right: nil, size: .init(width: 0, height: 44))
        self.btnResendCode.centerYAnchor.constraint(equalTo: self.lblResendCode.centerYAnchor).isActive = true
        self.btnResendCode.centerXAnchor.constraint(equalTo: self.lblResendCode.centerXAnchor).isActive = true
        
        self.btnConfirm.anchor(top: nil, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, right: self.contentView.rightAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .init(width: 0, height: 54))
    }
    
    @objc func btnEditPhonePressed(_ sender: UIButton) {
        self.delegate?.phoneViewDidRequestChangePhone(self)
    }
    
    @objc func btnResendCodePressed(_ sender: UIButton) {
        self.delegate?.phoneViewDidRequestResendCode(self)
        self.handleResendHideStatus(hideBtn: true)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func btnConfirmPressed(_ sender: UIButton) {
        self.delegate?.phoneView(self, didRequestPhoneValidationFor: self.code)
    }
    
    @objc func updateTimer() {
        self.resendCodeCount -= 1
        if self.resendCodeCount == 0 {
            self.timer.invalidate()
            self.resendCodeCount = self.resendCodeCounterValue
            self.handleResendHideStatus(hideBtn: false)
        }
    }
    
    func updatePhone(_ phone: String) {
        let formattedPhone = phone.westernArabicNumeralsOnly.formatted("(##) #####-####")
        self.lblPhone.text = formattedPhone
    }
    
    func handleResendHideStatus(hideBtn: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.lblResendCode.isHidden = !hideBtn
            self.btnResendCode.isHidden = hideBtn
        }) { _ in
            
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.pinInputView.becomeFirstResponder()
    }
    
    public func playProgress() {
        self.btnConfirm.startAnimation()
    }
    
    public func stopProgress(animationStyle: StopAnimationStyle = .normal, revertAfterDelay: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        self.btnConfirm.stopAnimation(animationStyle: animationStyle, revertAfterDelay: revertAfterDelay, completion: completion)
    }

}

extension PhoneView: PinTextInputViewDelegate {
    func pinTextInputViewShouldReturn(_ view: PinTextInputView) -> Bool {
        return true
    }
    
    
    func pinTextInputView(_ view: PinTextInputView, didChange code: String) {
        self.code = code
        let isValidCode = code.count == Int(view.maxNumberOfCharacters)
        self.btnConfirm.isEnabled = isValidCode
        if isValidCode {
            self.delegate?.phoneView(self, didRequestPhoneValidationFor: code)
        }
    }
    
}

extension String {
    
    func formatted(_ format: String) -> String {
        var formattedText = ""
        let formatArray = Array(format)
        var indexIncrease = 0
        
        for (index, char) in self.enumerated() {
            let increasedIndex = index + indexIncrease
            if formatArray.count > increasedIndex {
                while (formatArray.count > (index + indexIncrease)) && formatArray[(index + indexIncrease)] != "#" {
                    formattedText.append(formatArray[(index + indexIncrease)])
                    indexIncrease += 1
                }
                if (formatArray.count > (index + indexIncrease)) && formatArray[(index + indexIncrease)] == "#" {
                    formattedText.append(char)
                }
            } else {
                break
            }
        }
        return formattedText
    }
    
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
}
