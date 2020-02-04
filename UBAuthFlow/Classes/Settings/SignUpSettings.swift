//
//  SignUpSettings.swift
//  UBAuthFlow
//
//  Created by Usemobile on 23/05/19.
//

import Foundation

public class SignUpSettings {
    
    public var termsTextColor: UIColor
    public var imvAvatarBGColor: UIColor
    public var editBackgroundColor: UIColor
    
    public var termsTextFont: UIFont
    public var termsBtnFont: UIFont
    
    public var cameraImage: UIImage?
    public var editPhotoImage: UIImage?
    
    public var hasIndicationCode: Bool
    public var isCodeRequired: Bool
    
    public var hasUpdateUserAtSignUp: Bool = false
    public var hasEnrollment: Bool = false
    public var isGenderRequired: Bool = false
    public var currentLanguage: String = "pt-BR"
    
    public static var `default`: SignUpSettings {
        return SignUpSettings(termsTextFont: .systemFont(ofSize: 18),
                              termsBtnFont: .boldSystemFont(ofSize: 18))
    }
    
    public init(termsTextColor: UIColor = .black,
                imvAvatarBGColor: UIColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
                editBackgroundColor: UIColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1),
                termsTextFont: UIFont,
                termsBtnFont: UIFont,
                cameraImage: UIImage? = nil,
                editPhotoImage: UIImage? = nil,
                hasIndicationCode: Bool = true,
                isCodeRequired: Bool = false,
                currentLanguage: String = "pt-BR") {
        
        self.termsTextColor = termsTextColor
        self.imvAvatarBGColor = imvAvatarBGColor
        self.editBackgroundColor = editBackgroundColor
        
        self.termsTextFont = termsTextFont
        self.termsBtnFont = termsBtnFont
        
        self.cameraImage = cameraImage
        self.editPhotoImage = editPhotoImage
        
        self.hasIndicationCode = hasIndicationCode
        self.isCodeRequired = isCodeRequired
        self.currentLanguage = currentLanguage
    }
    
}

