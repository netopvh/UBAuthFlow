//
//  CoordinatedViewController.swift
//  USE_Coordinator
//
//  Created by Usemobile on 28/03/19.
//

import Foundation

open class CoordinatedViewController: UIViewController {
    open weak var coordinator: Coordinator?
    open weak var menuTintColor: UIColor? {
        return .black
    }
    open weak var menuImage: UIImage? {
        let frameWorkBundle = Bundle(for: CoordinatedViewController.self)
        if let bundleURL = frameWorkBundle.resourceURL?.appendingPathComponent("USE_Coordinator.bundle") , let resourceBundle = Bundle(url: bundleURL) {
            return UIImage(named: "menu", in: resourceBundle, compatibleWith: nil)
        }
        return nil
    }
    
    open func drawMenuButton() {
        let button = UIBarButtonItem(image: menuImage, style: .done, target: self, action: #selector(menuPressed))
        button.tintColor = menuTintColor ?? .black
        self.navigationItem.leftBarButtonItem = button
    }
    
    @objc open func menuPressed() {
        (self.coordinator as? SideMenuCoordinator)?.toggleMenu()
    }
}
