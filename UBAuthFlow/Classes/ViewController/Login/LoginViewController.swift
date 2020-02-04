//
//  LoginViewController.swift
//  UBAuthFlow
//
//  Created by Usemobile on 20/05/19.
//

import UIKit
import USE_Coordinator

protocol LoginViewControllerDelegate: class {
    func loginViewController(_ viewController: LoginViewController, didRequestLoginFor viewModel: LoginViewModel)
}

public class LoginViewController: CoordinatedViewController {
    
    lazy var loginView: LoginView = {
        let view = LoginView(settings: self.settings,
                             textFieldSettings: self.textFieldSettings,
                             buttonSettings: self.buttonSettings)
        view.delegate = self
        return view
    }()
    
    weak var delegate: LoginViewControllerDelegate?
    var settings: LoginSettings
    var textFieldSettings: TextFieldSettings
    var buttonSettings: ButtonSettings
    
    init(settings: LoginSettings,
         textFieldSettings: TextFieldSettings,
         buttonSettings: ButtonSettings) {
        
        self.settings = settings
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.textFieldSettings = .default
        self.buttonSettings = .default
        super.init(coder: aDecoder)
    }
    
    public override func loadView() {
        self.view = self.loginView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    public func stopProgress(success: Bool) {
        self.loginView.stopProgress(animationStyle: success ? .normal : .shake)
    }
    
}

extension LoginViewController: LoginViewDelegate {
    
    func loginView(_ view: LoginView, didTapEnterFor viewModel: LoginViewModel) {
        view.playProgress()
        self.delegate?.loginViewController(self, didRequestLoginFor: viewModel)
    }
    
    func loginView(_ view: LoginView, didTapForgotPasswordFor email: String) {
        (self.coordinator as? AuthCoordinator)?.presentForgotPassword(email: email)
    }
    
    func loginView(_ view: LoginView, didTapRegisterFor viewModel: LoginViewModel) {
        (self.coordinator as? AuthCoordinator)?.settings?.hasUpdateUserAtSignUp = false
        (self.coordinator as? AuthCoordinator)?.presentSignUp(loginViewModel: viewModel)
    }
    
}
