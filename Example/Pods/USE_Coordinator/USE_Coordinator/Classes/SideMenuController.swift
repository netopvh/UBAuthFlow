//
//  SideMenuController.swift
//  USE_Coordinator
//
//  Created by Usemobile on 01/04/19.
//

import UIKit

public class SideMenuController: UIViewController {
    
    public var coordinator: SideMenuCoordinator?
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    var beginTouchX: CGFloat = 0
    var allowDrag = false
    
    public func addOverlayToSubviews() {
        self.view.addSubview(self.overlayView)
    }
    
    public func configureGestures() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay))
        overlayView.addGestureRecognizer(tapGesture)
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragOverlay(_:)))
        dragGesture.delegate = self
        view.addGestureRecognizer(dragGesture)
    }
    
    @objc fileprivate func didTapOverlay() {
        self.coordinator?.toggleMenu()
    }
    
    @objc fileprivate func didDragOverlay(_ gesture: UIPanGestureRecognizer) {
        guard self.allowDrag else { return }
        guard gesture.translation(in: self.view).x <= 0 else { return }
        let cancelPercent: CGFloat = 0.3
        var percent = gesture.translation(in: self.view).x / UIScreen.main.bounds.width
        percent = percent < 0 ? -percent : percent
        switch gesture.state {
        case .began:
            self.beginTouchX = gesture.location(in: self.view).x
            if gesture.velocity(in: self.view).x <= -400 {
                self.coordinator?.toggleMenu()
            }
        case .changed:
            self.coordinator?.didDrag(for: self.beginTouchX - gesture.location(in: self.view).x)
        case .ended:
            if percent > cancelPercent || gesture.location(in: self.view).x < 0.1 * UIScreen.main.bounds.width {
                self.coordinator?.toggleMenu()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.coordinator?.didDrag(for: 0)
                }
            }
        case .cancelled, .failed:
            UIView.animate(withDuration: 0.3) {
                self.coordinator?.didDrag(for: 0)
            }
        default:
            break
        }
    }
}

extension SideMenuController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gesture.velocity(in: self.view)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
}
