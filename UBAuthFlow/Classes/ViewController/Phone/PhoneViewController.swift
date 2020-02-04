//
//  PhoneViewController.swift
//  UBAuthFlow
//
//  Created by Usemobile on 28/05/19.
//

import UIKit
import USE_Coordinator

protocol PhoneViewControllerDelegate: class {
    func phoneViewControllerDidRequestLogOut(_ viewController: PhoneViewController)
    func phoneViewControllerDidRequestResendCode(_ viewController: PhoneViewController)
    func phoneViewController(_ viewController: PhoneViewController, didRequestConfirm code: String)
}

class PhoneViewController: CoordinatedViewController {
    
    lazy var phoneView: PhoneView = {
        let view = PhoneView(settings: self.settings, buttonSettings: self.buttonSettings, phone: self.phone, currentLanguage: self.settings.currentLanguage)
        view.delegate = self
        return view
    }()
    
    weak var delegate: PhoneViewControllerDelegate?
    var settings: PhoneSettings
    var buttonSettings: ButtonSettings
    var phone: String = ""
    
    init(settings: PhoneSettings, buttonSettings: ButtonSettings, phone: String, currentLanguage: String) {
        self.settings = settings
        self.settings.currentLanguage = currentLanguage
        self.buttonSettings = buttonSettings
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.buttonSettings = .default
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.phoneView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = .phone
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.addLogoutButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let _ = self.phoneView.becomeFirstResponder()
        }
            UIApplication.shared.setStatusBarStyle(self.settings.prefferredStatusBayStyle, animated: true)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = nil
        }
        
        func addLogoutButton() {
            let button = UIBarButtonItem(title: .logOut, style: .plain, target: self, action: #selector(self.logoutPressed))
            button.tintColor = self.settings.prefferredStatusBayStyle == .default ? .black : .white
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func logoutPressed() {
        self.delegate?.phoneViewControllerDidRequestLogOut(self)
    }
    
    public func stopProgress(success: Bool) {
        self.phoneView.stopProgress(animationStyle: success ? .normal : .shake)
    }
    
    func updatePhone(_ phone: String) {
        self.phone = phone
        self.phoneView.updatePhone(phone)
    }
}

extension PhoneViewController: PhoneViewDelegate {
    func phoneViewDidRequestChangePhone(_ view: PhoneView) {
        (self.coordinator as? AuthCoordinator)?.presentChangePhone(phone: self.phone)
    }
    
    func phoneViewDidRequestResendCode(_ view: PhoneView) {
        self.delegate?.phoneViewControllerDidRequestResendCode(self)
    }
    
    func phoneView(_ view: PhoneView, didRequestPhoneValidationFor code: String) {
        view.playProgress()
        self.delegate?.phoneViewController(self, didRequestConfirm: code)
    }
}
