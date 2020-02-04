//
//  ButtonSettings.swift
//  UBAuthFlow
//
//  Created by Usemobile on 20/05/19.
//

import Foundation
import UIKit

public class ButtonSettings {
    
    public var textColor: UIColor
    public var enabledColor: UIColor
    public var disabledColor: UIColor
    public var highlightedColor: UIColor
    
    public var font: UIFont
    
    public static var `default`: ButtonSettings {
        return ButtonSettings(enabledColor: .purple,
                              disabledColor: .lightGray,
                              highlightedColor: UIColor.purple.withAlphaComponent(0.8),
                              font: .systemFont(ofSize: 20, weight: .black))
    }
    
    public init(textColor: UIColor = .white,
                enabledColor: UIColor,
                disabledColor: UIColor,
                highlightedColor: UIColor,
                font: UIFont) {
        
        self.textColor = textColor
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
        self.highlightedColor = highlightedColor
        
        self.font = font
    }
}
