//
//  Coordinator.swift
//  USE_Coordinator
//
//  Created by Usemobile on 28/03/19.
//

import Foundation

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    var topViewController: UIViewController? { get }
    
    func childDidFinish(_ child: Coordinator?)
}
