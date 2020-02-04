//
//  SignUpView.swift
//  UBAuthFlow
//
//  Created by Usemobile on 23/05/19.
//

import UIKit
import TPKeyboardAvoiding

protocol SignUpViewDelegate: class {
    func signUpView(_ view: SignUpView, didRequestSignUpFor viewModel: SignUpViewModel)
    func signUpViewDidRequestEditImage(_ view: SignUpView)
    func signUpViewDidRequestPresentTerms(_ view: SignUpView)
}

class SignUpView: UIView {
    
    // MARK: UI Components
    
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
    
    lazy var imvAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = self.settings.imvAvatarBGColor
        imageView.contentMode = .center
        imageView.image = UIImage.getFrom(customClass: SignUpView.self, nameResource: "camera")
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var viewEdit: UIView = {
        let view = UIView()
        view.backgroundColor = self.settings.editBackgroundColor
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var btnEditImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.getFrom(customClass: SignUpView.self, nameResource: "pencil"), for: .normal)
        button.backgroundColor = .clear
        let insets: CGFloat = 17
        button.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        button.addTarget(self, action: #selector(self.editImage(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    lazy var txfName: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.isUserInteractionEnabled = !self.settings.hasUpdateUserAtSignUp ? true : self.loginViewModel?.name == nil
        textField.defaultText = self.loginViewModel?.name
        textField.placeholder = .name
        textField.setupText()
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.name = text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            guard strongSelf.loginViewModel?.updateUser != true else { return }
            let _ = strongSelf.txfName.resignFirstResponder()
            let _ = strongSelf.txfGender.becomeFirstResponder()
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var txfGender: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.isUserInteractionEnabled = !self.settings.hasUpdateUserAtSignUp ? true : self.loginViewModel?.gender == nil
        textField.defaultText = self.loginViewModel?.gender
        textField.placeholder = .gender + (self.settings.isGenderRequired ? "" : .optional)
        textField.setupPicker([.male, .female])
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.gender = text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            guard strongSelf.loginViewModel?.updateUser != true else { return }
            strongSelf.gender = text
            strongSelf.checkButtonState()
            let _ = strongSelf.txfCPF.becomeFirstResponder()
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var txfCPF: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.isUserInteractionEnabled = !self.settings.hasUpdateUserAtSignUp ? true : self.loginViewModel?.cpf == nil
        textField.defaultText = self.loginViewModel?.cpf
        textField.placeholder = .cpf
        textField.setupCPF(language: self.settings.currentLanguage)
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.cpf = text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            guard strongSelf.loginViewModel?.updateUser != true else { return }
            let _ = strongSelf.txfEmail.becomeFirstResponder()
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var txfEmail: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.isUserInteractionEnabled = !self.settings.hasUpdateUserAtSignUp ? true : self.loginViewModel?.email == nil
        textField.defaultText = self.loginViewModel?.email ?? ""
        textField.placeholder = .email
        textField.setupEmail()
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.email = text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            guard strongSelf.loginViewModel?.updateUser != true else { return }
            let _ = strongSelf.txfPassword.becomeFirstResponder()
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var txfPassword: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.isUserInteractionEnabled = !self.settings.hasUpdateUserAtSignUp ? true : self.loginViewModel?.password == nil
        textField.defaultText = self.loginViewModel?.password ?? ""
        textField.placeholder = .password
        textField.setupPassword()
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.password = text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            guard strongSelf.loginViewModel?.updateUser != true else { return }
            let _ = strongSelf.txfPhone.becomeFirstResponder()
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var txfPhone: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.isUserInteractionEnabled = !self.settings.hasUpdateUserAtSignUp ? true : self.loginViewModel?.phone == nil
        textField.defaultText = self.loginViewModel?.phone
        textField.placeholder = .phone
        textField.setupPhone(language: self.settings.currentLanguage)
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.phone = text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            guard strongSelf.loginViewModel?.updateUser != true else { return }
            if strongSelf.hasIndicationCode && strongSelf.settings.isCodeRequired {
                let _ = strongSelf.txfIndicationCode.becomeFirstResponder()
            } else {
                if strongSelf.settings.hasEnrollment {
                    let _ = strongSelf.txfEnrollment.becomeFirstResponder()
                } else {
                    let _ = strongSelf.txfPhone.resignFirstResponder()
                }
            }
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var txfIndicationCode: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.placeholder = .indicationCode + (self.settings.isCodeRequired ? "" : .optional)
        textField.setupText()
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.indicationCode = text.isEmpty ? nil : text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            if strongSelf.settings.hasEnrollment {
                let _ = strongSelf.txfEnrollment.becomeFirstResponder()
            } else {
                let _ = strongSelf.txfIndicationCode.resignFirstResponder()
            }
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var txfEnrollment: MessageInputView = {
        let textField = MessageInputView(settings: self.textFieldSettings)
        textField.placeholder = .enrollment
        textField.setupText()
        textField.editingChanged = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            strongSelf.enrollment = text.isEmpty ? nil : text
            strongSelf.checkButtonState()
        }
        textField.returnPressed = { [weak self](text: String) in
            guard let strongSelf = self else { return }
            let _ = strongSelf.txfEnrollment.resignFirstResponder()
        }
        self.contentView.addSubview(textField)
        return textField
    }()
    
    lazy var btnRegister: SimpleButton = {
        let button = SimpleButton(settings: self.buttonSettings)
        button.spinnerColor = .white
        button.setTitle(self.loginViewModel?.updateUser == true ? .save : .registrate, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.registerPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    lazy var btnTerms: UIButton = {
        let button = UIButton(type: .system)
        let title = NSMutableAttributedString(string: .checkOur, attributes: [NSAttributedString.Key.font: self.settings.termsTextFont, NSAttributedString.Key.foregroundColor: self.settings.termsTextColor])
        title.append(NSAttributedString(string: .terms, attributes: [NSAttributedString.Key.font: self.settings.termsBtnFont, NSAttributedString.Key.foregroundColor: self.settings.termsTextColor]))
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(self.termsPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    // MARK: Properties
    
    weak var delegate: SignUpViewDelegate?
    
    var settings: SignUpSettings
    var textFieldSettings: TextFieldSettings
    var buttonSettings: ButtonSettings
    
    var avatar: UIImage? {
        didSet {
            self.imvAvatar.contentMode = .scaleToFill
            self.imvAvatar.image = self.avatar
        }
    }
    var name = ""
    var gender = "other"
    var cpf = ""
    var email = ""
    var password = ""
    var phone = ""
    var indicationCode: String? = nil
    var enrollment: String? = nil
    
    // MARK: Private Properties
    
    private var contentViewHeightConstraint = NSLayoutConstraint()
    private var hasIndicationCode: Bool 
    private var loginViewModel: LoginViewModel?
    
    // MARK: Life Cyclea
    
    init(settings: SignUpSettings,
         textFieldSettings: TextFieldSettings,
         buttonSettings: ButtonSettings,
         loginViewModel: LoginViewModel?,
         currentLanguage: String) {
        
        self.settings = settings
        self.settings.currentLanguage = currentLanguage
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        self.hasIndicationCode = settings.hasIndicationCode
        self.loginViewModel = loginViewModel
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.textFieldSettings = .default
        self.buttonSettings = .default
        self.hasIndicationCode = false
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentViewHeightConstraint.constant = -(self.getMargin())
        self.viewEdit.layer.cornerRadius = self.viewEdit.bounds.height / 2
        DispatchQueue.main.async {
            self.imvAvatar.applyCircle()
        }
    }
    
    // MARK: Setup
    
    private func setup() {
        self.backgroundColor = .white
        
        setupContentView()
        
        let imvSize: CGFloat = 110.dynamicCGFloat
        self.imvAvatar.anchor(top: self.contentView.topAnchor, left: nil, bottom: nil, right: nil, size: .init(width: imvSize, height: imvSize))
        self.imvAvatar.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.viewEdit.anchor(top: self.btnEditImage.topAnchor, left: self.btnEditImage.leftAnchor, bottom: nil, right: nil, padding: .init(top: 11, left: 11, bottom: 0, right: 0), size: .init(width: 28, height: 28))
        let btnEditImageSize: CGFloat = 50
        self.btnEditImage.anchor(top: nil, left: self.imvAvatar.leftAnchor, bottom: self.imvAvatar.bottomAnchor, right: nil, padding: .init(top: 0, left: -7, bottom: -7, right: 0), size: .init(width: btnEditImageSize, height: btnEditImageSize))
        
        setupTextFields()
        
        let buttonSpacing: CGFloat = 8.dynamicCGFloatUnlimited
        let textField = self.settings.hasEnrollment ? self.txfEnrollment : (self.hasIndicationCode ? self.txfIndicationCode : self.txfPhone)
        self.btnRegister.anchor(top: textField.bottomAnchor, left: textField.leftAnchor, bottom: nil, right: textField.rightAnchor, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 54.dynamicCGFloat))
        self.btnTerms.anchor(top: self.btnRegister.bottomAnchor, left: nil, bottom: self.contentView.bottomAnchor, right: nil, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 44.dynamicCGFloat))
        self.btnTerms.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.setupLoginViewModel()
    }
    
    fileprivate func setupContentView() {
        self.scrollView.fillSuperview()
        self.contentView.fillSuperview()
        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.contentViewHeightConstraint = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        self.contentViewHeightConstraint.priority = .defaultLow
        self.contentViewHeightConstraint.isActive = true
    }
    
    fileprivate func setupTextFields() {
        let buttonHeight: CGFloat = 54.dynamicCGFloat
        let buttonSpacing: CGFloat = 8.dynamicCGFloatUnlimited
        self.txfName.anchor(top: self.imvAvatar.bottomAnchor, left: self.contentView.leftAnchor, bottom: nil, right: self.contentView.rightAnchor, padding: .init(top: buttonSpacing, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: buttonHeight))
        self.txfGender.anchor(top: self.txfName.bottomAnchor, left: self.txfName.leftAnchor, bottom: nil, right: self.txfName.rightAnchor, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
        self.txfCPF.anchor(top: self.txfGender.bottomAnchor, left: self.txfGender.leftAnchor, bottom: nil, right: self.txfGender.rightAnchor, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
        self.txfEmail.anchor(top: self.txfCPF.bottomAnchor, left: self.txfCPF.leftAnchor, bottom: nil, right: self.txfCPF.rightAnchor, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
        self.txfPassword.anchor(top: self.txfEmail.bottomAnchor, left: self.txfEmail.leftAnchor, bottom: nil, right: self.txfEmail.rightAnchor, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
        self.txfPhone.anchor(top: self.txfPassword.bottomAnchor, left: self.txfPassword.leftAnchor, bottom: nil, right: self.txfPassword.rightAnchor, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
        if self.hasIndicationCode {
            self.txfIndicationCode.anchor(top: self.txfPhone.bottomAnchor, left: self.txfPhone.leftAnchor, bottom: nil, right: self.txfPhone.rightAnchor, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
        }
        if self.settings.hasEnrollment {
            self.txfEnrollment.anchor(top: (self.hasIndicationCode ? self.txfIndicationCode : self.txfPhone).bottomAnchor, left: self.txfPhone.leftAnchor, bottom: nil, right: self.txfPhone.rightAnchor, padding: .init(top: buttonSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: buttonHeight))
        }
    }
    
    fileprivate func setupLoginViewModel() {
        self.name = self.loginViewModel?.name ?? ""
        self.gender = self.loginViewModel?.gender ?? ""
        self.cpf = self.loginViewModel?.cpf ?? ""
        self.email = self.loginViewModel?.email ?? ""
        self.password = self.loginViewModel?.password ?? ""
        self.phone = self.loginViewModel?.phone ?? ""
        
        self.imvAvatar.cast(urlStr: self.loginViewModel?.profileImage ?? "", placeholder: self.imvAvatar.image) { (image, _) in
            if let _ = image {
                self.imvAvatar.contentMode = .scaleToFill
            }
        }
        self.checkButtonState()
    }
    
    private func checkButtonState() {
        if self.hasIndicationCode && self.settings.isCodeRequired {
            self.btnRegister.isEnabled = !self.name.isEmpty &&
                !self.cpf.isEmpty &&
                (!self.settings.isGenderRequired || !self.gender.isEmpty) &&
                !self.email.isEmpty &&
                !self.password.isEmpty &&
                !self.phone.isEmpty &&
                !(self.indicationCode ?? "").isEmpty &&
                (!self.settings.hasEnrollment || !(self.enrollment ?? "").isEmpty)
        } else {
            self.btnRegister.isEnabled = !self.name.isEmpty &&
                !self.cpf.isEmpty &&
                (!self.settings.isGenderRequired || !self.gender.isEmpty) &&
                !self.email.isEmpty &&
                !self.password.isEmpty &&
                !self.phone.isEmpty &&
                (!self.settings.hasEnrollment || !(self.enrollment ?? "").isEmpty)
        }
    }
    
    public func playProgress() {
        self.btnRegister.startAnimation()
    }
    
    public func stopProgress(animationStyle: StopAnimationStyle = .normal, revertAfterDelay: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        self.btnRegister.stopAnimation(animationStyle: animationStyle, revertAfterDelay: revertAfterDelay, completion: completion)
    }
    
    @objc func registerPressed(_ sender: SimpleButton) {
        self.endEditing(false)
        self.delegate?.signUpView(self,
                                  didRequestSignUpFor: SignUpViewModel(profileImage: self.avatar,
                                                                       name: self.name,
                                                                       gender: self.gender,
                                                                       cpf: self.cpf,
                                                                       email: self.email,
                                                                       password: self.password,
                                                                       phone: self.phone,
                                                                       indicationCode: self.indicationCode,
                                                                       enrollment: self.enrollment))
    }
    
    @objc func termsPressed(_ sender: UIButton) {
        self.endEditing(false)
        self.delegate?.signUpViewDidRequestPresentTerms(self)
    }
    
    @objc func editImage(_ sender: UIButton) {
        self.endEditing(false)
        self.delegate?.signUpViewDidRequestEditImage(self)
    }
    
}


extension UIImageView {
    
    func cast(urlStr: String, placeholder: UIImage? = nil, completion: ((UIImage?, String?) -> Void)? = nil) {
        self.image = placeholder
        guard let url = URL.init(string: urlStr) else {
            completion?(nil, nil)
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    let image: UIImage? = UIImage(data: data)
                    completion?(image, nil)
                    self.image = image ?? placeholder
                }
            } else if let error = error {
                completion?(nil, error.localizedDescription)
            } else {
                completion?(nil, nil)
            }
            }.resume()
    }
}
