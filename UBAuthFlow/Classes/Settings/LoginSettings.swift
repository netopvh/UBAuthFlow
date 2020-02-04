//
//  LoginSettings.swift
//  UBAuthFlow
//
//  Created by Usemobile on 20/05/19.
//

import Foundation
import UIKit

public class LoginSettings {
    
    public var forgotPasswordColor: UIColor
    public var signUpColor: UIColor
    
    public var forgotPasswordFont: UIFont
    public var signUpTextFont: UIFont
    public var signUpBtnFont: UIFont
    
    public var logo: UIImage?
    
    public var logoWidth: CGFloat = 0
    
    public var logoRatio: CGFloat = 1
    
    public static var `default`: LoginSettings {
        return LoginSettings(forgotPasswordFont: .systemFont(ofSize: 15, weight: .medium),
                             signUpTextFont: .systemFont(ofSize: 18, weight: .regular),
                             signUpBtnFont: .systemFont(ofSize: 18, weight: .bold))
    }
    
    public init(forgotPasswordColor: UIColor = .black,
                signUpColor: UIColor = .black,
                forgotPasswordFont: UIFont,
                signUpTextFont: UIFont,
                signUpBtnFont: UIFont) {
        
        self.forgotPasswordColor = forgotPasswordColor
        self.signUpColor = signUpColor
        
        self.forgotPasswordFont = forgotPasswordFont
        self.signUpTextFont = signUpTextFont
        self.signUpBtnFont = signUpBtnFont
        
    }
}
