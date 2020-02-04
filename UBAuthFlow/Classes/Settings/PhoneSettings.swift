//
//  PhoneSettings.swift
//  UBAuthFlow
//
//  Created by Usemobile on 28/05/19.
//

import Foundation

public class PhoneSettings {
    
    public var titleColor: UIColor
    public var textColor: UIColor
    public var phoneColor: UIColor
    public var editTintColor: UIColor
    public var codeTextColor: UIColor
    public var codeTintColor: UIColor
    public var timeColor: UIColor
    public var resendColor: UIColor
    
    public var titlePrefixFont: UIFont
    public var titleSufixFont: UIFont
    public var textFont: UIFont
    public var phoneFont: UIFont
    public var codeFont: UIFont
    public var timeFont: UIFont
    public var resendFont: UIFont
    
    public var editImage: UIImage?
    
    public var prefferredStatusBayStyle: UIStatusBarStyle = .lightContent
    
    public var currentLanguage: String
    
    public static var `default`: PhoneSettings {
        return PhoneSettings(titlePrefixFont: .systemFont(ofSize: 40, weight: .light), titleSufixFont: .boldSystemFont(ofSize: 40), textFont: .systemFont(ofSize: 24), phoneFont: .systemFont(ofSize: 20), codeFont: .italicSystemFont(ofSize: 30), timeFont: .systemFont(ofSize: 16), resendFont: .boldSystemFont(ofSize: 16))
    }
    
    public init(titleColor: UIColor = .black,
                textColor: UIColor = #colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.662745098, alpha: 1),
                phoneColor: UIColor = #colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.662745098, alpha: 1),
                editTintColor: UIColor = .black,
                codeTextColor: UIColor = #colorLiteral(red: 0.8666666667, green: 0.8784313725, blue: 0.8784313725, alpha: 1),
                codeTintColor: UIColor = .black,
                timeColor: UIColor = #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1),
                resendColor: UIColor = .black,
                titlePrefixFont: UIFont,
                titleSufixFont: UIFont,
                textFont: UIFont,
                phoneFont: UIFont,
                codeFont: UIFont,
                timeFont: UIFont,
                resendFont: UIFont,
                editImage: UIImage? = nil,
                currentLanguage: String = "pt-BR") {
        
        self.titleColor = titleColor
        self.textColor = textColor
        self.phoneColor = phoneColor
        self.editTintColor = editTintColor
        self.codeTextColor = codeTextColor
        self.codeTintColor = codeTintColor
        self.timeColor = timeColor
        self.resendColor = resendColor
        
        self.titlePrefixFont = titlePrefixFont
        self.titleSufixFont = titleSufixFont
        self.textFont = textFont
        self.phoneFont = phoneFont
        self.codeFont = codeFont
        self.timeFont = timeFont
        self.resendFont = resendFont
        
        self.editImage = editImage
        self.currentLanguage = currentLanguage
    }
    
}
