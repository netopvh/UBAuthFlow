//
//  EditPhoneViewController.swift
//  UBAuthFlow
//
//  Created by Usemobile on 04/07/19.
//

import UIKit
import USE_Coordinator

protocol EditPhoneViewControllerDelegate: class {
    func editPhoneViewControllerDidRequestLogout(_ viewController: EditPhoneViewController)
    func editPhoneViewController(_ viewController: EditPhoneViewController, didRequestUpate phone: String)
}

class EditPhoneViewController: CoordinatedViewController {
    
    // MARK: - UI Components
    
    lazy var editPhoneView: EditPhoneView = {
        let view = EditPhoneView(settings: self.settings,
                                 textFieldSettings: self.textFieldSettings,
                                 buttonSettings: self.buttonSettings,
                                 phone: self.phone,
                                 currentLanguage: self.settings.currentLanguage)
        view.delegate = self
//        self.view.addSubview(self.editPhoneView)
        return view
    }()
    
    // MARK: - Properties
    
    weak var delegate: EditPhoneViewControllerDelegate?
    
    var settings: EditPhoneSettings
    var textFieldSettings: TextFieldSettings
    var buttonSettings: ButtonSettings
    var phone: String
    
    init(settings: EditPhoneSettings,
         textFieldSettings: TextFieldSettings,
         buttonSettings: ButtonSettings,
         phone: String,
         currentLanguage: String) {
        
        self.settings = settings
        self.settings.currentLanguage = currentLanguage
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.textFieldSettings = .default
        self.buttonSettings = .default
        self.phone = ""
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = self.editPhoneView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = .phone
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.addLogoutButton()
    }
    
    func addLogoutButton() {
        let button = UIBarButtonItem(title: .logOut, style: .plain, target: self, action: #selector(self.logoutPressed))
        button.tintColor = self.navigationController?.navigationBar.tintColor ?? .white
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func logoutPressed() {
        self.delegate?.editPhoneViewControllerDidRequestLogout(self)
    }
    
    public func stopProgress(success: Bool) {
        self.editPhoneView.stopProgress(animationStyle: success ? .normal : .shake)
    }
    
}

extension EditPhoneViewController: EditPhoneViewDelegate {
    func editPhoneView(_ view: EditPhoneView, didRequestResend phone: String) {
        view.playProgress()
        self.delegate?.editPhoneViewController(self, didRequestUpate: phone)
    }
}
