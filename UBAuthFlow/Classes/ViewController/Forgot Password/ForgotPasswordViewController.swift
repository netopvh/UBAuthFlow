//
//  ForgotPasswordViewController.swift
//  UBAuthFlow
//
//  Created by Usemobile on 27/05/19.
//

import UIKit
import USE_Coordinator

protocol ForgotPasswordViewControllerDelegate: class {
    func forgotPasswordViewController(_ viewController: ForgotPasswordViewController, didRequestRecoverPasswordFor email: String)
}

class ForgotPasswordViewController: CoordinatedViewController {

    lazy var forgotPasswordView: ForgotPasswordView = {
        let view = ForgotPasswordView(settings: self.settings,
                                      textFieldSettings: self.textFieldSettings,
                                      buttonSettings: self.buttonSettings,
                                      email: self.email)
        view.delegate = self
        return view
    }()
    
    weak var delegate: ForgotPasswordViewControllerDelegate?
    var settings: ForgotPasswordSettings
    var textFieldSettings: TextFieldSettings
    var buttonSettings: ButtonSettings
    
    var email: String = ""
    
    init(settings: ForgotPasswordSettings,
         textFieldSettings: TextFieldSettings,
         buttonSettings: ButtonSettings,
         email: String) {
        
        self.settings = settings
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.textFieldSettings = .default
        self.buttonSettings = .default
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = self.forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func stopProgress(success: Bool) {
        self.forgotPasswordView.stopProgress(animationStyle: success ? .normal : .shake)
    }
    
}

extension ForgotPasswordViewController: ForgotPasswordViewDelegate {
    func forgotPasswordViewClosePressed(_ view: ForgotPasswordView) {
        (self.coordinator as? AuthCoordinator)?.finishForgotPassword()
    }
    
    func forgotPasswordView(_ view: ForgotPasswordView, btnRecoverPressedFor email: String) {
        view.playProgress()
        self.delegate?.forgotPasswordViewController(self, didRequestRecoverPasswordFor: email)
    }
}
