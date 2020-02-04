//
//  NavigationCoordinator.swift
//  USE_Coordinator
//
//  Created by Usemobile on 29/03/19.
//

import Foundation

open class NavigationCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    public var childCoordinators: [Coordinator]
    public var parentCoordinator: Coordinator?
    public var topViewController: UIViewController? {
        get {
            if let childCoordinator = self.childCoordinators.last {
                return childCoordinator.topViewController
            } else {
                return self.navigationController.children.last
            }
        }
    }
    
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        super.init()
        self.navigationController.delegate = self
    }
    
    public func start(root: CoordinatedViewController) {
        root.coordinator = self
        self.navigationController.pushViewController(root, animated: true)
    }
    
    public func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators .remove(at: index)
                break
            }
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        if let viewController = fromViewController as? CoordinatedViewController {
            childDidFinish(viewController.coordinator)
        }
    }
}
