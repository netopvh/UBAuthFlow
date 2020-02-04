//
//  ForgotPasswordSettings.swift
//  UBAuthFlow
//
//  Created by Usemobile on 27/05/19.
//

import Foundation


public class ForgotPasswordSettings {
    
    public var orientationsColor: UIColor
    public var closeColor: UIColor
    
    public var orientationsFont: UIFont
    
    public var closeImage: UIImage?
    public var logo: UIImage?
    
    public var logoWidth: CGFloat = 0
    
    public var logoRatio: CGFloat = 1
    
    public static var `default`: ForgotPasswordSettings {
        return ForgotPasswordSettings(orientationsFont: .systemFont(ofSize: 18, weight: .medium))
    }
    
    public init(orientationsColor: UIColor = .black, closeColor: UIColor = .black, orientationsFont: UIFont, closeImage: UIImage? = nil) {
        self.orientationsColor = orientationsColor
        self.closeColor = closeColor
        
        self.orientationsFont = orientationsFont
        
        self.closeImage = closeImage
    }
}
