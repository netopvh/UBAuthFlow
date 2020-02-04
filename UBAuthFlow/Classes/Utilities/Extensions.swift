//
//  Extensions.swift
//  UBAuthFlow
//
//  Created by Tulio Parreiras on 20/05/19.
//  Copyright (c) 2019 Usemobile. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func getFrom(customClass: AnyClass, nameResource: String) -> UIImage? {
        let frameWorkBundle = Bundle(for: customClass)
        if let bundleURL = frameWorkBundle.resourceURL?.appendingPathComponent("UBAuthFlow.bundle"), let resourceBundle = Bundle(url: bundleURL) {
            return UIImage(named: nameResource, in: resourceBundle, compatibleWith: nil)
        }
        return nil
    }
}


extension UIView {
    
    func getMargin() -> CGFloat {
        if #available(iOS 11, *) {
            return self.safeAreaInsets.top + self.safeAreaInsets.bottom
        } else {
            return UIApplication.shared.statusBarFrame.size.height + 44
        }
    }
    
    func applyLightShadowToCircle() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
    }
    
    func applyCircle() {
        self.setCorner(self.bounds.height/2)
    }
    
    func setCorner(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero, size: CGSize = .zero, useSafeArea: Bool = false) {
        self.anchor(top: self.superview?.topAnchor, left: self.superview?.leftAnchor, bottom: self.superview?.bottomAnchor, right: self.superview?.rightAnchor, padding: padding, size: size)
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
            
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -padding.right).isActive = true
            
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
            
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
}


extension UIViewController {
    
    static var top: UIViewController? {
        get {
            return topViewController()
        }
    }
    
    static var root: UIViewController? {
        get {
            return UIApplication.shared.delegate?.window??.rootViewController
        }
    }
    
    static func topViewController(from viewController: UIViewController? = UIViewController.root) -> UIViewController? {
        if let tabBarViewController = viewController as? UITabBarController {
            return topViewController(from: tabBarViewController.selectedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return topViewController(from: presentedViewController)
        } else {
            return viewController
        }
    }
}


extension String {
    
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = self.range(of: emailRegEx, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    var isValidCPF: Bool {
        let numbers = self.compactMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
}


extension Int {
    var dynamic: Int {
        let aux: Int = self * Int(UIScreen.main.bounds.height) / 667
        return aux > self ? self : aux
    }
    var dynamicCGFloat: CGFloat {
        return CGFloat(self).dynamic
    }
    var dynamicUnlimited: Int {
        return self * Int(UIScreen.main.bounds.height) / 667
    }
    var dynamicCGFloatUnlimited: CGFloat {
        return CGFloat(self).dynamicUnlimited
    }
    func toRadians() -> CGFloat {
        return CGFloat(self).toRadians()
    }
}

extension Double {
    var dynamic: Double {
        return Double(self.dynamicCGFloat)
    }
    var dynamicCGFloat: CGFloat {
        return CGFloat(self).dynamic
    }
    var dynamicUnlimited: Double {
        return Double(self.dynamicCGFloatUnlimited)
    }
    var dynamicCGFloatUnlimited: CGFloat {
        return CGFloat(self).dynamicUnlimited
    }
}

extension CGFloat {
    var dynamic: CGFloat {
        let aux: CGFloat = self * UIScreen.main.bounds.height / 667
        return aux > self ? self : aux
    }
    var dynamicUnlimited: CGFloat {
        return self * UIScreen.main.bounds.height / 667
    }
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
