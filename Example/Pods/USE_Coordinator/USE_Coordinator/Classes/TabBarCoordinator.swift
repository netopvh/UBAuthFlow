//
//  TabBarCoordinator.swift
//  USE_Coordinator
//
//  Created by Usemobile on 29/03/19.
//

import Foundation

open class TabBarCoordinator: NSObject, Coordinator {
    
    public var childCoordinators: [Coordinator]
    public var parentCoordinator: Coordinator?
    public var topViewController: UIViewController? {
        get { 
            let selectedIndex = self.tabBarController.selectedIndex
            if let viewControllers = self.tabBarController.viewControllers, viewControllers.count > selectedIndex {
                let presentedVC = viewControllers[selectedIndex]
                if let nav = presentedVC as? UINavigationController, let navRoot = nav.children.first  {
                    if let coordinatedVC = navRoot as? CoordinatedViewController, let coordinator = coordinatedVC.coordinator {
                        switch coordinator {
                        case is NavigationCoordinator:
                            return coordinator.topViewController
                        default:
                            return coordinatedVC
                        }
                    }
                    return navRoot
                }
                return presentedVC
            }
            return nil
            
        }
    }
    
    public var tabBarController: UITabBarController
    
    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.childCoordinators = []
    }
    
    public func start(roots: [UIViewController]) {
        roots.forEach { if let vc = $0 as? CoordinatedViewController {
            vc.coordinator = self
            }}
        self.tabBarController.viewControllers = roots
    }
    
    public func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators .remove(at: index)
                break
            }
        }
    }
}

