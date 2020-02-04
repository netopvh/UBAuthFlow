//
//  LoginView.swift
//  UBAuthFlow
//
//  Created by Usemobile on 20/05/19.
//

import Foundation
import UIKit
import TPKeyboardAvoiding

protocol LoginViewDelegate: class {
    func loginView(_ view: LoginView, didTapEnterFor viewModel: LoginViewModel)
    func loginView(_ view: LoginView, didTapForgotPasswordFor email: String)
    func loginView(_ view: LoginView, didTapRegisterFor viewModel: LoginViewModel)
}

class LoginView: UIView {
    
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
    
    lazy var imvLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.settings.logo
        imageView.contentMode = .scaleToFill
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var txfEmail: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.placeholder = .email
        textField.setupEmail()
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.email = text
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.email = text
            let _ = strongSelf.txfPassword.becomeFirstResponder()
        }
        textField.setCorner(27)
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var txfPassword: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.placeholder = .password
        textField.setupPassword()
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.password = text
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.password = text
            let _ = strongSelf.txfPassword.resignFirstResponder()
            strongSelf.enterPressed(strongSelf.btnEnter)
        }
        textField.setCorner(27)
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var btnEnter: SimpleButton = {
        let button = SimpleButton(settings: self.buttonSettings)
        button.spinnerColor = .white
        button.setTitle(.login, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.enterPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    lazy var btnForgotPassword: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = self.settings.forgotPasswordFont
        button.setTitleColor(self.settings.forgotPasswordColor, for: .normal)
        button.setTitle(.forgotPassword, for: .normal)
        button.addTarget(self, action: #selector(self.forgotPasswordPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    lazy var btnRegister: UIButton = {
        let button = UIButton(type: .system)
        let title = NSMutableAttributedString(string: .applyYour, attributes: [NSAttributedString.Key.font: self.settings.signUpTextFont, NSAttributedString.Key.foregroundColor: self.settings.signUpColor])
        title.append(NSAttributedString(string: .registration, attributes: [NSAttributedString.Key.font: self.settings.signUpBtnFont, NSAttributedString.Key.foregroundColor: self.settings.signUpColor]))
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(self.registerPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: LoginViewDelegate?
    
    var settings: LoginSettings
    var textFieldSettings: TextFieldSettings
    var buttonSettings: ButtonSettings
    
    var email = "" {
        didSet {
            self.checkButtonState()
        }
    }
    var password = "" {
        didSet {
            self.checkButtonState()
        }
    }
    
    // MARK: - Private Properties
    
    private var cnstLogoWidth = NSLayoutConstraint()
    private var contentViewHeightConstraint = NSLayoutConstraint()
//    var cnstLogoTop = NSLayoutConstraint()
    
    // MARK: - Life Cycle
    
    init(settings: LoginSettings, textFieldSettings: TextFieldSettings, buttonSettings: ButtonSettings) {
        self.settings = settings
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.textFieldSettings = .default
        self.buttonSettings = .default
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentViewHeightConstraint.constant = -(self.getMargin())
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.backgroundColor = .white
        setupConstraints()
        
        self.txfEmail.anchor(top: self.imvLogo.bottomAnchor, left: self.contentView.leftAnchor, bottom: nil, right: self.contentView.rightAnchor, padding: .init(top: 40, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 54))
        self.txfPassword.anchor(top: self.txfEmail.bottomAnchor, left: self.txfEmail.leftAnchor, bottom: nil, right: self.txfEmail.rightAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 54))
        self.btnEnter.anchor(top: self.txfPassword.bottomAnchor, left: self.txfPassword.leftAnchor, bottom: nil, right: self.txfPassword.rightAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 54))
        self.btnForgotPassword.anchor(top: self.btnEnter.bottomAnchor, left: nil, bottom: nil, right: nil, padding: .init(top: 22, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 44))
        self.btnForgotPassword.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.btnRegister.anchor(top: nil, left: nil, bottom: self.contentView.bottomAnchor, right: nil, padding: .init(top: 0, left: 0, bottom: 20, right: 0), size: .init(width: 0, height: 44))
        self.btnRegister.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    }
    
    fileprivate func setupConstraints() {
        self.scrollView.fillSuperview()
        self.contentView.fillSuperview()
        self.contentViewHeightConstraint = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        self.contentViewHeightConstraint.isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.imvLogo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        self.cnstLogoWidth = self.imvLogo.widthAnchor.constraint(equalToConstant: self.settings.logoWidth)
        self.cnstLogoWidth.isActive = true
        self.imvLogo.heightAnchor.constraint(equalTo: self.imvLogo.widthAnchor, multiplier: self.settings.logoRatio).isActive = true
        self.imvLogo.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    }
    
    @objc func enterPressed(_ sender: SimpleButton) {
        self.endEditing(false)
        self.delegate?.loginView(self,
                                 didTapEnterFor: LoginViewModel(email: self.email,
                                                                      password: self.password))
    }
    
    @objc func forgotPasswordPressed(_ sender: UIButton) {
        self.endEditing(false)
        self.delegate?.loginView(self, didTapForgotPasswordFor: self.email)
    }
    
    @objc func registerPressed(_ sender: UIButton) {
        self.endEditing(false)
        self.delegate?.loginView(self,
                                 didTapRegisterFor: LoginViewModel(email: self.email,
                                                                   password: self.password))
    }
    
    private func checkButtonState() {
        self.btnEnter.isEnabled = !self.email.isEmpty && !self.password.isEmpty
    }
    
    public func playProgress() {
        self.btnEnter.startAnimation()
    }
    
    public func stopProgress(animationStyle: StopAnimationStyle = .normal, revertAfterDelay: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        self.btnEnter.stopAnimation(animationStyle: animationStyle, revertAfterDelay: revertAfterDelay, completion: completion)
    }
}
