//
//  SideMenuCoordinator.swift
//  USE_Coordinator
//
//  Created by Usemobile on 01/04/19.
//

import Foundation
import UIKit

open class SideMenuCoordinator: NSObject, Coordinator {
    
    public var childCoordinators: [Coordinator]
    public var parentCoordinator: Coordinator?
    open var topViewController: UIViewController? {
        if self.isMenuPresented {
            return self.menu
        } else {
            if let lastChild = self.childCoordinators.last {
                return lastChild.topViewController
            } else {
                if let presentVC = self.presentController {
                    return presentVC
                } else {
                    return root
                }
            }
            
        }
    }
    open var menuWidthRatio: CGFloat {
        return 2/3
    }
    
    public func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators .remove(at: index)
                break
            }
        }
    }
    
    var menu: CoordinatedViewController
    var root: CoordinatedViewController?
    var navigation: UINavigationController?
    public var presentController: UIViewController?
    public var isMenuPresented: Bool = false
    public var sideMenuController: SideMenuController?
    
    private enum RootType {
        case navigation
        case viewController
    }
    private var type: RootType = .navigation
    
    convenience public init(root: CoordinatedViewController, menu: CoordinatedViewController) {
        self.init(menu: menu)
        self.root = root
        self.root?.coordinator = self
        self.type = .viewController
    }
    
    convenience public init(navigation: UINavigationController, root: CoordinatedViewController, menu: CoordinatedViewController) {
        self.init(menu: menu)
        self.navigation = navigation
        self.root = root
        self.type = .navigation
    }
    
    private init(menu: CoordinatedViewController) {
        self.menu = menu
        self.childCoordinators = []
        super.init()
        self.menu.coordinator = self
    }
    
    public func start() {
        guard let root = self.root else { return }
        let vc = SideMenuController()
        vc.coordinator = self
        let bounds = UIScreen.main.bounds
        let width = bounds.width * self.menuWidthRatio
        self.menu.view.frame = .init(x: -width, y: 0, width: width, height: bounds.height)
        
        if self.type == .navigation {
            vc.add(self.navigation)
            self.navigation?.pushViewController(root, animated: true)
        } else {
            vc.add(root)
        }
        vc.addOverlayToSubviews()
        vc.add(self.menu)
        
        vc.configureGestures()
        
        self.sideMenuController = vc
    }
    
    public func toggleMenu() {
        self.isMenuPresented = !self.isMenuPresented
        self.sideMenuController?.allowDrag = self.isMenuPresented
        let bounds = UIScreen.main.bounds
        let width = bounds.width * menuWidthRatio
        let x: CGFloat = self.isMenuPresented ? 0 : -width
        let vc = self.type == .navigation ? self.navigation : self.root
        UIView.animate(withDuration: 0.3, animations: {
            self.menu.view.frame = .init(x: x, y: 0, width: width, height: bounds.height)
            vc?.view.frame = .init(x: (x+width), y: 0, width: bounds.width, height: bounds.height)
            self.sideMenuController?.overlayView.alpha = self.isMenuPresented ? 0.5 : 0
        }) { _ in
        }
    }
    
    public func presentRoot() {
        if self.isMenuPresented {
            self.toggleMenu()
        }
        if let vc = self.presentController {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
    
    func didDrag(for value: CGFloat) {
        let bounds = UIScreen.main.bounds
        let width = bounds.width * menuWidthRatio
        let minX = -width
        let negativeValue = -(value)
        let minNormalizedX = negativeValue < minX ? minX : negativeValue
        let x = (minNormalizedX > 0.0 ? 0.0 : minNormalizedX)
        self.menu.view.frame = CGRect(x: x, y: 0, width: width, height: bounds.height)
        let vc = self.type == .navigation ? self.navigation : self.root
        vc?.view.frame = CGRect(x: width + x, y: 0, width: bounds.width, height: bounds.height)
    }
}


public extension UIViewController {
    public func add(_ child: UIViewController?) {
        guard let child = child else { return }
        self.addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
