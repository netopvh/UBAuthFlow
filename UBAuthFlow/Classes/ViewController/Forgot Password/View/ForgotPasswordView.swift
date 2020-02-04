//
//  ForgotPasswordView.swift
//  UBAuthFlow
//
//  Created by Usemobile on 27/05/19.
//

import UIKit
import TPKeyboardAvoiding

protocol ForgotPasswordViewDelegate: class {
    func forgotPasswordViewClosePressed(_ view: ForgotPasswordView)
    func forgotPasswordView(_ view: ForgotPasswordView, btnRecoverPressedFor email: String)
}

class ForgotPasswordView: UIView {
    
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
    
    lazy var btnClose: UIButton = {
        let button = UIButton(type: .system)
        let image = self.settings.closeImage ?? UIImage.getFrom(customClass: ForgotPasswordView.self, nameResource: "close")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = self.settings.closeColor
        let insets: CGFloat = 11
        button.imageEdgeInsets = .init(top: insets, left: insets, bottom: insets, right: insets)
        button.addTarget(self, action: #selector(self.closePressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    lazy var lblOrientations: UILabel = {
        let label = UILabel()
        label.text = .enterEmail
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = self.settings.orientationsFont
        label.textColor = self.settings.orientationsColor
        self.contentView.addSubview(label)
        return label
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
        textField.defaultText = self.email
        textField.placeholder = .email
        textField.setupEmail()
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.email = text
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.email = text
            strongSelf.btnRecoverPressed(strongSelf.btnRecover)
        }
        textField.setCorner(27)
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var btnRecover: SimpleButton = {
        let button = SimpleButton(settings: self.buttonSettings)
        button.spinnerColor = .white
        button.setTitle(.recover, for: .normal)
        button.isEnabled = !self.email.isEmpty
        button.addTarget(self, action: #selector(self.btnRecoverPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    // MARK: - Properties
    
    var settings: ForgotPasswordSettings
    var textFieldSettings: TextFieldSettings
    var buttonSettings: ButtonSettings
    
    weak var delegate: ForgotPasswordViewDelegate?
    
    var email = "" {
        didSet {
            self.btnRecover.isEnabled = !self.email.isEmpty
        }
    }
    
    private var cnstLogoWidth = NSLayoutConstraint()
    private var contentViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Life Cycle
    
    init(settings: ForgotPasswordSettings,
         textFieldSettings: TextFieldSettings,
         buttonSettings: ButtonSettings,
         email: String) {
        self.settings = settings
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        self.email = email
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
    
    // MARK: - Methods
    
    private func setup() {
        self.backgroundColor = .white
        
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.scrollView.fillSuperview()
        self.contentView.fillSuperview()
        self.contentViewHeightConstraint = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        self.contentViewHeightConstraint.isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        if #available(iOS 11, *) {
            self.btnClose.anchor(top: self.contentView.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: self.contentView.safeAreaLayoutGuide.rightAnchor, size: .init(width: 44, height: 44))
            self.imvLogo.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        } else {
            self.btnClose.anchor(top: self.contentView.topAnchor, left: nil, bottom: nil, right: self.contentView.rightAnchor, size: .init(width: 44, height: 44))
            self.imvLogo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40).isActive = true
        }
        self.cnstLogoWidth = self.imvLogo.widthAnchor.constraint(equalToConstant: self.settings.logoWidth)
        self.cnstLogoWidth.isActive = true
        self.imvLogo.heightAnchor.constraint(equalTo: self.imvLogo.widthAnchor, multiplier: self.settings.logoRatio).isActive = true
        self.imvLogo.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.lblOrientations.anchor(top: self.imvLogo.bottomAnchor, left: self.contentView.leftAnchor, bottom: nil, right: self.contentView.rightAnchor, padding: .init(top: 10, left: 16, bottom: 0, right: 16))
        
        self.txfEmail.anchor(top: self.lblOrientations.bottomAnchor, left: self.contentView.leftAnchor, bottom: nil, right: self.contentView.rightAnchor, padding: .init(top: 15, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 54))
        
        self.btnRecover.anchor(top: self.txfEmail.bottomAnchor, left: self.txfEmail.leftAnchor, bottom: nil, right: self.txfEmail.rightAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 54))
    }
    
    public func playProgress() {
        self.btnRecover.startAnimation()
    }
    
    public func stopProgress(animationStyle: StopAnimationStyle = .normal, revertAfterDelay: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        self.btnRecover.stopAnimation(animationStyle: animationStyle, revertAfterDelay: revertAfterDelay, completion: completion)
    }
    
    @objc func closePressed(_ sender: UIButton) {
        self.delegate?.forgotPasswordViewClosePressed(self)
    }
    
    @objc func btnRecoverPressed(_ sender: SimpleButton) {
        let _ = self.txfEmail.resignFirstResponder()
        self.delegate?.forgotPasswordView(self, btnRecoverPressedFor: self.email)
    }

}
