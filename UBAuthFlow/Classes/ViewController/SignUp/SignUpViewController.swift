//
//  SignUpViewController.swift
//  UBAuthFlow
//
//  Created by Usemobile on 23/05/19.
//

import UIKit
import USE_Coordinator
import Photos
import MobileCoreServices

protocol SignUpViewControllerDelegate: class {
    func signUpViewController(_ viewController: SignUpViewController, didRequestSignUpFor viewModel: SignUpViewModel)
    func signUpViewControllerDidRequestPresentTerms(_ viewController: SignUpViewController)
    func signUpViewControllerDidRequestLogOut(_ viewController: SignUpViewController)
}

class SignUpViewController: CoordinatedViewController {
    
    lazy var signUpView: SignUpView = {
        let view = SignUpView(settings: self.settings,
                              textFieldSettings: self.textFieldSettings,
                              buttonSettings: self.buttonSettings,
                              loginViewModel: self.loginViewModel,
                              currentLanguage: self.settings.currentLanguage)
        view.delegate = self
        return view
    }()
    
    weak var delegate: SignUpViewControllerDelegate?
    
    var settings: SignUpSettings
    var textFieldSettings: TextFieldSettings
    var buttonSettings: ButtonSettings
    
    var loginViewModel: LoginViewModel?
    
    let picker      = UIImagePickerController()
    var chosenImage: UIImage?
    
    init(settings: SignUpSettings,
         textFieldSettings: TextFieldSettings,
         buttonSettings: ButtonSettings,
         loginViewModel: LoginViewModel?,
         currentLanguage: String) {
        
        self.settings = settings
        self.settings.currentLanguage = currentLanguage
        self.textFieldSettings = textFieldSettings
        self.buttonSettings = buttonSettings
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        self.textFieldSettings = .default
        self.buttonSettings = .default
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        if self.loginViewModel?.updateUser == true {
            self.navigationItem.setHidesBackButton(true, animated:false)
            self.addLogoutButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    func addLogoutButton() {
        let button = UIBarButtonItem(title: .logOut, style: .plain, target: self, action: #selector(self.logoutPressed))
        button.tintColor = .black
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func logoutPressed() {
        self.delegate?.signUpViewControllerDidRequestLogOut(self)
    }
    
    func getPhotoFromLibrary() {
        self.picker.allowsEditing = true
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = [kUTTypeImage as NSString as String]
        present(picker, animated: true, completion: nil)
        
    }
    
    func getPhotoFromCamera() {
        self.picker.allowsEditing = true
        self.picker.sourceType = .camera
        self.picker.cameraCaptureMode = .photo
        self.picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    func presentPhotoActionSheet() {
        let alertController = UIAlertController(title: .selectImage, message: nil, preferredStyle: .actionSheet)
        let bCamera = UIAlertAction(title: .takePicture, style: .default) { (action) in
            self.getPhotoFromCamera()
        }
        let bLibrary = UIAlertAction(title: .chooseLibrary, style: .default) { (action) in
            self.getPhotoFromLibrary()
        }
        let bCancel = UIAlertAction(title: .cancel, style: .cancel, handler: nil)
        alertController.addAction(bCamera)
        alertController.addAction(bLibrary)
        alertController.addAction(bCancel)
        alertController.popoverPresentationController?.sourceView = self.view
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    func stopProgress(success: Bool) {
        self.signUpView.stopProgress(animationStyle: success ? .normal : .shake)
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.chosenImage = image
            self.signUpView.avatar = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: UINavigationControllerDelegate { }


extension SignUpViewController: SignUpViewDelegate {
    
    func signUpViewDidRequestEditImage(_ view: SignUpView) {
        self.presentPhotoActionSheet()
    }
    
    func signUpView(_ view: SignUpView, didRequestSignUpFor viewModel: SignUpViewModel) {
        view.playProgress()
        self.delegate?.signUpViewController(self, didRequestSignUpFor: viewModel)
    }
    
    func signUpViewDidRequestPresentTerms(_ view: SignUpView) {
        self.delegate?.signUpViewControllerDidRequestPresentTerms(self)
    }
    
}
