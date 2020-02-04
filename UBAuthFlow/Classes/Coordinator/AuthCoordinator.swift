//
//  AuthCoordinator.swift
//  Pods-UBAuthFlow_Example
//
//  Created by Tulio Parreiras on 20/05/19.
//  Copyright (c) 2019 Usemobile. All rights reserved.
//

import Foundation
import USE_Coordinator

public protocol AuthCoordinatorDelegate: class {
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestLoginFor viewModel: LoginViewModel, returnWithSuccess: @escaping (Bool) -> Void)
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestSignUpFor viewModel: SignUpViewModel, returnWithSuccess: @escaping (Bool) -> Void)
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestRecoverPasswordFor email: String, finishedRecovery: @escaping (Bool) -> Void)
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestConfirm code: String, finishedConfirm: @escaping (Bool) -> Void)
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestUpdate phone: String, finishedUpdate: @escaping (Bool) -> Void)
    func authCoordinatorDidRequestTerms(_ coordinator: AuthCoordinator)
    func authCoordinatorDidRequestLogOut(_ coordinator: AuthCoordinator, isEditPhoneFlow: Bool)
    func authCoordinatorDidRequestResendCode(_ coordinator: AuthCoordinator)
}

public class AuthCoordinator: NavigationCoordinator {
    
    public var settings: AuthSettings?
    public var phoneFlowSettings: PhoneFlowSettings?
    public weak var delegate: AuthCoordinatorDelegate?
    
    public func start(settings: AuthSettings) {
        self.settings = settings
        let initialVC = InitialViewController(settings: settings.initialSettings)
        self.start(root: initialVC)
    }
    
    public func startPhoneFlow(settings: PhoneFlowSettings, phone: String) {
        self.phoneFlowSettings = settings
        let phoneVC = PhoneViewController(settings: settings.phoneSettings, buttonSettings: settings.buttonSettings, phone: phone, currentLanguage: settings.language.rawValue )
        phoneVC.delegate = self
        self.start(root: phoneVC)
    }
    
    func presentLogin() {
        guard let settings = self.settings else { return }
        let nextVC = LoginViewController(settings: settings.loginSettings, textFieldSettings: settings.textFieldSettings, buttonSettings: settings.buttonSettings)
        nextVC.delegate = self
        nextVC.coordinator = self
        self.navigationController.pushViewController(nextVC, animated: true)
    }
    
    public func presentSignUp(loginViewModel: LoginViewModel? = nil) {
        let settings = self.settings ?? .default
        let signUpViewController = SignUpViewController(settings: settings.signUpSettings, textFieldSettings: settings.textFieldSettings, buttonSettings: settings.buttonSettings, loginViewModel: loginViewModel, currentLanguage: settings.language.rawValue)
        signUpViewController.delegate = self
        signUpViewController.coordinator = self
        self.navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func presentForgotPassword(email: String = "") {
        let settings = self.settings ?? .default
        let forgotPasswordViewController = ForgotPasswordViewController(settings: settings.forgotPasswordSettings,
                                                                        textFieldSettings: settings.textFieldSettings,
                                                                        buttonSettings: settings.buttonSettings,
                                                                        email: email)
        forgotPasswordViewController.delegate = self
        forgotPasswordViewController.coordinator = self
        self.navigationController.present(forgotPasswordViewController, animated: true, completion: nil)
    }
    
    func finishForgotPassword() {
        if let presentedViewController = self.navigationController.presentedViewController as? ForgotPasswordViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func presentPhone(phone: String) {
        let settings = self.settings ?? .default
        let phoneViewController = PhoneViewController(settings: settings.phoneSettings, buttonSettings: settings.buttonSettings, phone: phone, currentLanguage: self.settings?.language.rawValue ?? "pt-BR")
        phoneViewController.delegate = self
        phoneViewController.coordinator = self
        self.navigationController.pushViewController(phoneViewController, animated: true)
    }
    
    func presentChangePhone(phone: String) {
        let editPhoneSettings = self.settings?.editPhoneSettings ?? self.phoneFlowSettings?.editPhoneSettings ?? .default
        let textFieldSettings = self.settings?.textFieldSettings ?? self.phoneFlowSettings?.textFieldSettings ?? .default
        let buttonSettings = self.settings?.buttonSettings ?? self.phoneFlowSettings?.buttonSettings ?? .default
        let editPhoneViewController = EditPhoneViewController(settings: editPhoneSettings,
                                                              textFieldSettings: textFieldSettings,
                                                              buttonSettings: buttonSettings,
                                                              phone: phone,
                                                              currentLanguage: self.phoneFlowSettings?.language.rawValue ?? "pt-BR")
        editPhoneViewController.delegate = self
        editPhoneViewController.coordinator = self
        self.navigationController.pushViewController(editPhoneViewController, animated: true)
    }
    
    private func requestLogout() {
        self.delegate?.authCoordinatorDidRequestLogOut(self, isEditPhoneFlow: self.phoneFlowSettings != nil)
    }
    
    private func updatePhone(phone: String) {
        if let viewController = self.navigationController.children.last as? PhoneViewController {
            viewController.updatePhone(phone)
        }
    }
    
}

extension AuthCoordinator: LoginViewControllerDelegate {
    func loginViewController(_ viewController: LoginViewController, didRequestLoginFor viewModel: LoginViewModel) {
        self.delegate?.authCoordinator(self, didRequestLoginFor: viewModel, returnWithSuccess: { [weak viewController](success: Bool) in
            guard let viewController = viewController else { return }
            viewController.stopProgress(success: success)
        })
    }
}

extension AuthCoordinator: SignUpViewControllerDelegate {
    
    func signUpViewControllerDidRequestLogOut(_ viewController: SignUpViewController) {
        self.requestLogout()
    }
    
    
    func signUpViewControllerDidRequestPresentTerms(_ viewController: SignUpViewController) {
        self.delegate?.authCoordinatorDidRequestTerms(self)
    }
    
    func signUpViewController(_ viewController: SignUpViewController, didRequestSignUpFor viewModel: SignUpViewModel) {
        self.delegate?.authCoordinator(self, didRequestSignUpFor: viewModel, returnWithSuccess: { [weak viewController](success: Bool) in
            guard let viewController = viewController else { return }
            viewController.stopProgress(success: success)
        })
    }
    
}

extension AuthCoordinator: ForgotPasswordViewControllerDelegate {
    func forgotPasswordViewController(_ viewController: ForgotPasswordViewController, didRequestRecoverPasswordFor email: String) {
        self.delegate?.authCoordinator(self, didRequestRecoverPasswordFor: email, finishedRecovery: { [weak self](success: Bool) in
            guard let strongSelf = self else { return }
            viewController.stopProgress(success: success)
            if success {
                strongSelf.finishForgotPassword()
            }
        })
    }
}

extension AuthCoordinator: PhoneViewControllerDelegate {
    
    func phoneViewControllerDidRequestLogOut(_ viewController: PhoneViewController) {
        self.requestLogout()
    }
    
    func phoneViewControllerDidRequestResendCode(_ viewController: PhoneViewController) {
        self.delegate?.authCoordinatorDidRequestResendCode(self)
    }
    
    func phoneViewController(_ viewController: PhoneViewController, didRequestConfirm code: String) {
        self.delegate?.authCoordinator(self, didRequestConfirm: code, finishedConfirm: { [weak viewController](succes: Bool) in
            guard let strongViewController = viewController else { return }
            strongViewController.stopProgress(success: succes)
        })
    }

}

extension AuthCoordinator: EditPhoneViewControllerDelegate {
    func editPhoneViewController(_ viewController: EditPhoneViewController, didRequestUpate phone: String) {
        self.delegate?.authCoordinator(self, didRequestUpdate: phone, finishedUpdate: { [weak viewController](success: Bool) in
            guard let strongViewController = viewController else { return }
            strongViewController.stopProgress(success: success)
            if success {
                if let _ = self.navigationController.children.last as? EditPhoneViewController {
                    self.navigationController.popViewController(animated: true)
                } else if let viewController = self.navigationController.presentedViewController as? EditPhoneViewController {
                    viewController.dismiss(animated: true, completion: nil)
                }
                self.updatePhone(phone: phone)
            }
        })
    }
    
    func editPhoneViewControllerDidRequestLogout(_ viewController: EditPhoneViewController) {
        self.requestLogout()
    }
}
