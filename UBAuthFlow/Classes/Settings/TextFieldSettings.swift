//
//  TextFieldSettings.swift
//  UBAuthFlow
//
//  Created by Usemobile on 20/05/19.
//

import Foundation
import UIKit

public class TextFieldSettings {
    
    public var hasContentBorderColor: UIColor
    public var unSelectedBorderColor: UIColor
    public var selectedBorderColor: UIColor
    public var textColor: UIColor
    public var placeholderColor: UIColor
    
    public var font: UIFont
    public var placeholderFont: UIFont
    
    public var hasSecurityImage: UIImage?
    public var noSecurityImage: UIImage?
    
    public var borderWidth: CGFloat
    
    public static var `default`: TextFieldSettings {
        return TextFieldSettings(hasContentBorderColor: .black,
                                 font: .systemFont(ofSize: 18, weight: .semibold),
                                 placeholderFont: .systemFont(ofSize: 18, weight: .regular))
    }
    
    public init(hasContentBorderColor: UIColor,
                unSelectedBorderColor: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 0.1),
                selectedBorderColor: UIColor = .gray,
                textColor: UIColor = .gray,
                placeholderColor: UIColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1), font: UIFont,
                placeholderFont: UIFont,
                hasSecurityImage: UIImage? = nil,
                noSecurityImage: UIImage? = nil, borderWidth: CGFloat = 1.0) {
        
        self.hasContentBorderColor = hasContentBorderColor
        self.unSelectedBorderColor = unSelectedBorderColor
        self.selectedBorderColor = selectedBorderColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        
        self.font = font
        self.placeholderFont = placeholderFont
        
        self.hasSecurityImage = hasSecurityImage
        self.noSecurityImage = noSecurityImage
        
        self.borderWidth = borderWidth
    }
}
