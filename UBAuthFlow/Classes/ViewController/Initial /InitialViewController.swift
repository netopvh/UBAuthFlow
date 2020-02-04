
//
//  InitialViewController.swift
//  PinCodeTextField
//
//  Created by Tulio Parreiras on 20/05/19.
//  Copyright (c) 2019 Usemobile. All rights reserved.
//

import UIKit
import USE_Coordinator

public class InitialViewController: CoordinatedViewController {
    
    // MARK: - UI Components
    
    lazy var initialView: InitialView = {
        let view = InitialView(settings: self.settings)
        view.delegate = self
        return view
    }()
    
    // MARK: - Properties
    
    var settings: InitialSettings
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cycle
    
    init(settings: InitialSettings) {
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public override func loadView() {
        self.view = self.initialView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.initialView.animateLogo()
        }
    }

}

extension InitialViewController: InitialViewDelegate {
    func initialViewSignUpPressed(_ view: InitialView) {
        (self.coordinator as? AuthCoordinator)?.presentSignUp()
    }
    
    func initialViewLoginPressed(_ view: InitialView) {
        (self.coordinator as? AuthCoordinator)?.presentLogin()
    }
}
