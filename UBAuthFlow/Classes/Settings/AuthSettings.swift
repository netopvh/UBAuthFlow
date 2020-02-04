//
//  AuthSettings.swift
//  UBAuthFlow
//
//  Created by Tulio Parreiras on 20/05/19.
//  Copyright (c) 2019 Usemobile. All rights reserved.
//

import Foundation
import UIKit

var safeAreaMargin: CGFloat {
    if #available(iOS 11, *) {
        let window = UIApplication.shared.keyWindow?.window
        return (window?.safeAreaInsets.bottom ?? 0) + (window?.safeAreaInsets.top ?? 0)
    } else {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

public enum AuthLanguage: String {
    case en = "en-US"
    case pt = "pt-BR"
    case es = "es-BO"

}

var currentLanguage: AuthLanguage = .pt

public class AuthSettings {
    
    public var language: AuthLanguage = .pt {
        didSet {
            currentLanguage = language
        }
    }
    
    public var textFieldSettings: TextFieldSettings
    public var buttonSettings: ButtonSettings
    public var initialSettings: InitialSettings
    public var loginSettings: LoginSettings
    public var signUpSettings: SignUpSettings
    public var forgotPasswordSettings: ForgotPasswordSettings
    public var phoneSettings: PhoneSettings
    public var editPhoneSettings: EditPhoneSettings
    
    public var hasUpdateUserAtSignUp: Bool = false {
        didSet {
            self.signUpSettings.hasUpdateUserAtSignUp = self.hasUpdateUserAtSignUp
        }
    }
    
    public var hasEnrollment: Bool = false {
        didSet {
            self.signUpSettings.hasEnrollment = self.hasEnrollment
        }
    }
    
    public var hasIndicationCode: Bool = false {
        didSet {
            self.signUpSettings.hasIndicationCode = self.hasIndicationCode
        }
    }
    public var isGenderRequired: Bool = false {
        didSet {
            self.signUpSettings.isGenderRequired = self.isGenderRequired
        }
    }
    
    public static var `default`: AuthSettings {
        return AuthSettings(logoLoginFlow: nil, logoLoginFlowWidth: 106)
    }
    
    public init(logoLoginFlow: UIImage?,
                logoLoginFlowWidth: CGFloat,
                logoLoginRatio: CGFloat = 1,
                textFieldSettings: TextFieldSettings = .default,
                buttonSettings: ButtonSettings = .default,
                initialSettings: InitialSettings = .default,
                loginSettings: LoginSettings = .default,
                signUpSettings: SignUpSettings = .default,
                forgotPasswordSettings: ForgotPasswordSettings = .default,
                phoneSettings: PhoneSettings = .default,
                editPhoneSettings: EditPhoneSettings = .default) {
        
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        self.initialSettings = initialSettings
        self.loginSettings = loginSettings
        self.signUpSettings = signUpSettings
        self.forgotPasswordSettings = forgotPasswordSettings
        self.phoneSettings = phoneSettings
        self.editPhoneSettings = editPhoneSettings
        
        self.loginSettings.logo = logoLoginFlow
        self.loginSettings.logoWidth = logoLoginFlowWidth
        self.loginSettings.logoRatio = logoLoginRatio
        
        self.forgotPasswordSettings.logo = logoLoginFlow
        self.forgotPasswordSettings.logoWidth = logoLoginFlowWidth
        self.forgotPasswordSettings.logoRatio = logoLoginRatio
    }
    
}

public class PhoneFlowSettings {
    
    public var language: AuthLanguage = .pt {
        didSet {
            currentLanguage = self.language
        }
    }
    
    public var textFieldSettings: TextFieldSettings
    public var buttonSettings: ButtonSettings
    public var phoneSettings: PhoneSettings
    public var editPhoneSettings: EditPhoneSettings
    
    public static var `default`: PhoneFlowSettings {
        return PhoneFlowSettings()
    }
    
    public init(textFieldSettings: TextFieldSettings = .default,
                buttonSettings: ButtonSettings = .default,
                phoneSettings: PhoneSettings = .default,
                editPhoneSettings: EditPhoneSettings = .default) {
        
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        self.phoneSettings = phoneSettings
        self.editPhoneSettings = editPhoneSettings
        
    }
    
}
