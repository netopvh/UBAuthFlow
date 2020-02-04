//
//  AppDelegate.swift
//  UBAuthFlow
//
//  Created by Tulio de Oliveira Parreiras on 05/20/2019.
//  Copyright (c) 2019 Tulio de Oliveira Parreiras. All rights reserved.
//

import UIKit
import UBAuthFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var authCoordinator: AuthCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        self.setupPhoneFlow()
        self.setupInitialFlow()
        return true
    }
    
    func setupInitialFlow() {
        let navigation = BaseNavigation()
        navigation.navigationBar.tintColor = .black
        let coordinator = AuthCoordinator(navigationController: navigation)
        coordinator.delegate = self
        let settings = AuthSettings.default
        settings.isGenderRequired = true
//        settings.hasIndicationCode = false
//        settings.hasEnrollment = true
//        settings.language = .es
        settings.initialSettings.backgroundImage = #imageLiteral(resourceName: "background-welcome")
        settings.initialSettings.logo = #imageLiteral(resourceName: "logo-white")
        settings.initialSettings.secondLogo = #imageLiteral(resourceName: "logo-text")  
        settings.initialSettings.hasTwoLogos = true
        settings.initialSettings.logoRatio = 67.61/201.03
        settings.initialSettings.logoWidthBig = 201
        settings.initialSettings.logoWidthSmall = 146
        settings.loginSettings.logo = #imageLiteral(resourceName: "logo-1")
        settings.loginSettings.logoWidth = 117
        settings.forgotPasswordSettings.logo = #imageLiteral(resourceName: "logo-1")
        settings.forgotPasswordSettings.logoWidth = 117
        settings.signUpSettings.isCodeRequired = true
        settings.hasUpdateUserAtSignUp = true
        coordinator.start(settings: settings)
        self.authCoordinator = coordinator
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
    }
    
    func setupPhoneFlow() {
        let navigation = BaseNavigation()
        let coordinator = AuthCoordinator(navigationController: navigation)
        coordinator.delegate = self
        let phoneSettings = PhoneFlowSettings.default
//        phoneSettings.language = .es
        if phoneSettings.language.rawValue == "es-BO"{
            coordinator.startPhoneFlow(settings: phoneSettings, phone: "12345678")
        }else{
            coordinator.startPhoneFlow(settings: phoneSettings, phone: "31984923952")
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        self.authCoordinator = coordinator

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

class BaseNavigation: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = .blue
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .white
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension AppDelegate: AuthCoordinatorDelegate {
    
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestLoginFor viewModel: LoginViewModel, returnWithSuccess: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            returnWithSuccess(true)
            if viewModel.updateUser == true {
                viewModel.gender = "m"
                viewModel.cpf = "86138724763"
                viewModel.profileImage = "http://mobdrive-api.usemobile.com.br/use/files/FNIDBEI5GWNIDNIDA63OP5WNIDIDIWHNID/dc83ee41efec32fcbc0b93feabb680c2_1556303888.1585689.png"
                coordinator.presentSignUp(loginViewModel: viewModel)
            } else {
                coordinator.presentPhone(phone: "(31) 98492-3952")
            }
            coordinator.navigationController.navigationBar.tintColor = .white
        }
    }
    
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestRecoverPasswordFor email: String, finishedRecovery: @escaping (Bool) -> Void) {
        print("EMAIL: ", email)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            finishedRecovery(false)
        }
    }
    
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestSignUpFor viewModel: SignUpViewModel, returnWithSuccess: @escaping (Bool) -> Void) {
        if let _ = viewModel.profileImage {
            do {
                let json = try viewModel.getJSON(profileImageLink: "")
                print("Sign Up JSON: ", json)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    returnWithSuccess(true)
                }
            } catch (let jsonError) {
                returnWithSuccess(false)
                if let error = jsonError as? CustomError {
                    print("Error: ", error.localizedDescription)
                } else {
                    print("Error: ", jsonError.localizedDescription)
                }
            }
        } else {
            returnWithSuccess(false)
        }
    }
    
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestConfirm code: String, finishedConfirm: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            finishedConfirm(Bool.random())
        }
    }
    
    func authCoordinator(_ coordinator: AuthCoordinator, didRequestUpdate phone: String, finishedUpdate: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            finishedUpdate(Bool.random())
        }
    }
    
    func authCoordinatorDidRequestTerms(_ coordinator: AuthCoordinator) {
        print("authCoordinatorDidRequestTerms")
    }
    
    func authCoordinatorDidRequestLogOut(_ coordinator: AuthCoordinator, isEditPhoneFlow: Bool) {
        if !isEditPhoneFlow {
            coordinator.navigationController.popToRootViewController(animated: true)
        }
        print("Is Edit Phone Flow: ", isEditPhoneFlow)
        print("authCoordinatorDidRequestLogOut")
    }
    
    func authCoordinatorDidRequestResendCode(_ coordinator: AuthCoordinator) {
        coordinator.navigationController.navigationBar.tintColor = .black
        print("authCoordinatorDidRequestResendCode")
    }
}
