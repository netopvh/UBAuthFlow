//
//  EditPhoneSettings.swift
//  UBAuthFlow
//
//  Created by Usemobile on 04/07/19.
//

import Foundation


public class EditPhoneSettings {
    
    public var titleFont: UIFont
    public var subTitleFont: UIFont
    
    public var titleColor: UIColor
    public var subTitleColor: UIColor
    
    public var currentLanguage: String
    
    public static var `default`: EditPhoneSettings {
        return EditPhoneSettings(titleFont: .systemFont(ofSize: 40),
                                 subTitleFont: .systemFont(ofSize: 20))
    }
    
    public init(titleFont: UIFont,
                subTitleFont: UIFont,
                titleColor: UIColor = .black,
                subTitleColor: UIColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1),
                currentLanguage: String = "pt-BR") {
        self.titleFont = titleFont
        self.subTitleFont = subTitleFont
        
        self.titleColor = titleColor
        self.subTitleColor = subTitleColor
        self.currentLanguage = currentLanguage
    }
    
}
