//
//  InitialSettings.swift
//  UBAuthFlow
//
//  Created by Usemobile on 20/05/19.
//

import Foundation
import UIKit

public class InitialSettings {
    
    public var signUpColor: UIColor
    public var loginColor: UIColor
    public var versionColor: UIColor
    
    public var signUpFont: UIFont
    public var loginTextFont: UIFont
    public var loginBtnFont: UIFont
    public var versionFont: UIFont
    
    public var backgroundImage: UIImage?
    public var logo: UIImage?
    
    public var logoWidthSmall: CGFloat
    public var logoWidthBig: CGFloat
    public var logoRatio: CGFloat // H x W
    
    public var hasTwoLogos: Bool = false
    public var secondLogo: UIImage? = nil
    
    public static var `default`: InitialSettings {
        return InitialSettings(signUpFont: .systemFont(ofSize: 20, weight: .black),
                               loginTextFont: .systemFont(ofSize: 18),
                               loginBtnFont: .boldSystemFont(ofSize: 18),
                               versionFont: .systemFont(ofSize: 13),
                               backgroundImage: nil, logo: nil)
    }
    
    public init(signUpColor: UIColor = .white,
                loginColor: UIColor = .white,
                versionColor: UIColor = UIColor.white.withAlphaComponent(0.55),
                signUpFont: UIFont,
                loginTextFont: UIFont,
                loginBtnFont: UIFont,
                versionFont: UIFont,
                backgroundImage: UIImage?,
                logo: UIImage?,
                logoWidthSmall: CGFloat = 74,
                logoWidthBig: CGFloat = 237,
                logoRatio: CGFloat = 1) {
        
        self.signUpColor = signUpColor
        self.loginColor = loginColor
        self.versionColor = versionColor
        
        self.signUpFont = signUpFont
        self.loginTextFont = loginTextFont
        self.loginBtnFont = loginBtnFont
        self.versionFont = versionFont
        
        self.backgroundImage = backgroundImage
        self.logo = logo
        
        self.logoWidthSmall = logoWidthSmall
        self.logoWidthBig   = logoWidthBig
        self.logoRatio      = logoRatio
    }
}
