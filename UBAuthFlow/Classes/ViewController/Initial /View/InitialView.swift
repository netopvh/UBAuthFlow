//
//  InitialView.swift
//  UBAuthFlow
//
//  Created by Tulio Parreiras on 20/05/19.
//  Copyright (c) 2019 Usemobile. All rights reserved.
//

import UIKit

protocol InitialViewDelegate: class {
    func initialViewSignUpPressed(_ view: InitialView)
    func initialViewLoginPressed(_ view: InitialView)
}

class InitialView: UIView {
    
    // MARK: - UI Components
    
    lazy var imvBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.settings.backgroundImage
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var imvLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.settings.logo
        imageView.contentMode = .scaleToFill
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var imvSecondLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.settings.secondLogo
        imageView.contentMode = .scaleToFill
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var btnSignUp: UIButton = {
        let button = UIButton(type: .system)
        button.alpha = 0
        button.titleLabel?.font = self.settings.signUpFont
        button.setTitleColor(self.settings.signUpColor, for: .normal)
        button.setTitle(.signUp, for: .normal)
        button.layer.borderColor = self.settings.signUpColor.cgColor
        button.layer.borderWidth = 1.5
        button.addTarget(self, action: #selector(self.signUpPressed(_:)), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var viewLogin: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .clear
        self.addSubview(view)
        return view
    }()
    
    lazy var lblLogin: UILabel = {
        let label = UILabel()
        label.font = self.settings.loginTextFont
        label.textColor = self.settings.loginColor
        label.text = .hasAccount
        self.viewLogin.addSubview(label)
        return label
    }()
    
    lazy var btnLogin: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = self.settings.loginBtnFont
        button.setTitleColor(self.settings.loginColor, for: .normal)
        button.setTitle(.signIn, for: .normal)
        button.addTarget(self, action: #selector(self.loginPressed(_:)), for: .touchUpInside)
        self.viewLogin.addSubview(button)
        return button
    }()
    
    lazy var lblVersion: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = self.settings.versionFont
        label.textColor = self.settings.versionColor
        label.text = self.versionText
        self.addSubview(label)
        return label
    }()
    
    // MARK: - Properties
    
    var settings: InitialSettings
    weak var delegate: InitialViewDelegate?
    
    // MARK: - Private Properties
    
    private var versionText: String {
        let infoDictionary = Bundle.main.infoDictionary
        let version = infoDictionary?["CFBundleShortVersionString"] as? String
        let name = infoDictionary?["CFBundleDisplayName"] as? String
        if let _version = version {
            if let _name = name {
                return _name + " v" + _version + "c"
            } else {
                return "v" + _version + "c"
            }
        }
        return ""
    }
    private var cnstLogoWidth = NSLayoutConstraint()
    private var cnstLogoTop = NSLayoutConstraint()
    private var hasAnimated: Bool = false
    var logoSize: CGSize? {
        return self.settings.logo?.size
    }
    
    var secondLogoSize: CGSize? {
        return self.settings.secondLogo?.size
    }
    
    var defaultScreenWidth: CGFloat = 375
    var defaultLogoLeadingSpacing: CGFloat = 24
    var widthRatio: CGFloat {
        return screenSize.width / self.defaultScreenWidth
    }
    
    // MARK: - Life Cycle
    
    init(settings: InitialSettings) {
        self.settings = settings
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.btnSignUp.layer.cornerRadius = self.btnSignUp.frame.height/2
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.backgroundColor = .white
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.imvBackground.fillSuperview(padding: .init(top: 0, left: -1, bottom: 0, right: -1))
        let bottomPadding: CGFloat = -18
        if #available(iOS 11.0, *) {
            self.lblVersion.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding).isActive = true
        } else {
            self.lblVersion.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomPadding).isActive = true
        }
        self.lblVersion.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.viewLogin.anchor(top: nil, left: nil, bottom: self.lblVersion.topAnchor, right: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 0, height: 44))
        self.viewLogin.centerXAnchor.constraint(equalTo: self.lblVersion.centerXAnchor).isActive = true
        self.lblLogin.anchor(top: self.viewLogin.topAnchor, left: self.viewLogin.leftAnchor, bottom: self.viewLogin.bottomAnchor, right: nil)
        self.btnLogin.anchor(top: self.viewLogin.topAnchor, left: self.lblLogin.rightAnchor, bottom: self.viewLogin.bottomAnchor, right: self.viewLogin.rightAnchor)
        self.btnSignUp.anchor(top: nil, left: nil, bottom: self.viewLogin.topAnchor, right: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 0, height: 54))
        self.btnSignUp.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 323/375).isActive = true
        self.btnSignUp.centerXAnchor.constraint(equalTo: self.viewLogin.centerXAnchor).isActive = true
        
        self.setupLogos()
        
    }
    
    var logoLeadingSmall: CGFloat {
        let secondLogoWidth = (self.secondLogoSize?.width ?? 74.33) * self.widthRatio
        let logoWidth = self.settings.logoWidthBig
        let leading = ((self.defaultScreenWidth * self.widthRatio) - logoWidth - secondLogoWidth - (self.defaultLogoLeadingSpacing * self.widthRatio)) / 2
        return leading
    }
    
    var logoLeadingBig: CGFloat {
        let logoWidth = self.settings.logoWidthSmall
        let leading = (self.defaultScreenWidth - logoWidth) / 2
        return leading * self.widthRatio
    }
    
    private func setupLogos() {
        self.imvLogo.heightAnchor.constraint(equalTo: self.imvLogo.widthAnchor, multiplier: self.settings.logoRatio).isActive = true
        self.cnstLogoWidth = self.imvLogo.widthAnchor.constraint(equalToConstant: self.settings.logoWidthBig)
        self.cnstLogoWidth.isActive = true
        let top = (UIScreen.main.bounds.height - (self.settings.logoWidthBig * self.settings.logoRatio)) / 2
        self.cnstLogoTop = self.imvLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: top)
        self.cnstLogoTop.isActive = true
        if self.settings.hasTwoLogos {
            let secondLogoWidth = self.secondLogoSize?.width ?? 74.33
            let secondLogoHeight = self.secondLogoSize?.height ?? 23.59
            self.imvSecondLogo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: secondLogoWidth/375).isActive = true
            self.imvSecondLogo.widthAnchor.constraint(equalTo: self.imvSecondLogo.heightAnchor, multiplier: secondLogoWidth/secondLogoHeight).isActive = true
            self.imvSecondLogo.centerYAnchor.constraint(equalTo: self.imvLogo.centerYAnchor).isActive = true
            self.cnstLogoLeading = self.imvLogo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.logoLeadingSmall)
            self.cnstLogoLeading.isActive = true
            self.cnstSecondLogoLeading = self.imvSecondLogo.leftAnchor.constraint(equalTo: self.imvLogo.rightAnchor, constant: self.defaultLogoLeadingSpacing * self.widthRatio)
            self.cnstSecondLogoLeading.isActive = true
        } else {
            self.imvLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
    
    func animateLogo() {
        guard !self.hasAnimated else { return }
        self.hasAnimated = true
        let duration: Double = 0.7
        if self.settings.hasTwoLogos {
            self.animateDoubleLogo(with: duration)
        } else {
            self.animateSoloLogo(with: duration)
        }
    }
    
    private func animateSoloLogo(with duration: Double) {
        self.cnstLogoWidth.constant = self.settings.logoWidthSmall
        self.cnstLogoTop.constant = 40
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
        UIView.animate(withDuration: 2*duration) {
            self.viewLogin.alpha = 1
            self.btnSignUp.alpha = 1
            self.lblVersion.alpha = 1
        }
    }
    
    private func animateDoubleLogo(with duration: Double) {
        self.firstAnimation(true)
        UIView.animate(withDuration: duration, animations: {
            self.imvSecondLogo.alpha = 0
            self.layoutIfNeeded()
        }) { _ in
            self.secondAnimation(true)
            UIView.animate(withDuration: duration) {
                self.layoutIfNeeded()
            }
        }
        UIView.animate(withDuration: duration*2) {
            self.viewLogin.alpha = 1
            self.btnSignUp.alpha = 1
        }
    }
    
    private var cnstLogoLeading = NSLayoutConstraint()
    private var cnstSecondLogoLeading = NSLayoutConstraint()
    
    private func firstAnimation(_ animated: Bool) {
        let leading = (animated ? self.logoLeadingBig : self.logoLeadingSmall)
        print(leading)
        self.cnstLogoLeading.constant = leading
        self.cnstSecondLogoLeading.constant = animated ? -((self.secondLogoSize?.width ?? 74.33) * self.widthRatio) : 24
        
    }
    
    private func secondAnimation(_ animated: Bool) {
        let top = (UIScreen.main.bounds.height - (self.settings.logoWidthBig * self.settings.logoRatio)) / 2
        self.cnstLogoWidth.constant = animated ? self.settings.logoWidthSmall : self.settings.logoWidthBig
        self.cnstLogoTop.constant = animated ? (32 * self.widthRatio) : top
    }
    
    @objc func signUpPressed(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        self.delegate?.initialViewSignUpPressed(self)
        sender.isUserInteractionEnabled = true
    }
    
    @objc func loginPressed(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        self.delegate?.initialViewLoginPressed(self)
        sender.isUserInteractionEnabled = true
    }
}



extension UIDevice {
    
    static let isXFamily: Bool = {
        return UIScreen.main.bounds.size.height >= 895
    }()
}
