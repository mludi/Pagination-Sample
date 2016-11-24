//
//  AppDelegate.swift
//  Client
//
//  Created by Matthias Ludwig on 21.11.16.
//  Copyright © 2016 Matthias Ludwig. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CreateDemoDataViewControllerDelegate {

    // MARK: - Properties
    
    var window: UIWindow?

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "createdData") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let createDemoDataViewController = storyboard.instantiateViewController(withIdentifier: "CreateDemoDataViewController") as? CreateDemoDataViewController
            createDemoDataViewController?.delegate = self
            window?.rootViewController = createDemoDataViewController
        }
        return true
    }
    
    // MARK: - CreateDemoDataViewControllerDelegate
    
    func createDemoDataViewControllerDidFinish() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "createdData")
        setupNormalViewController(animated: true)
    }
    
    // MARK: - Helper
    
    fileprivate func setupNormalViewController(animated inAnimated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postViewController = storyboard.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController
        if inAnimated {
            UIView.animate(withDuration: 1.0, animations: { [weak self] in
                self?.window?.rootViewController = postViewController
            })
        }
        else {
            window?.rootViewController = postViewController
        }
    }
}

