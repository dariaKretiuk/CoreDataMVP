//
//  AppDelegate.swift
//  CoreDataMVP
//
//  Created by Дарья Кретюк on 22.06.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let viewController = ViewController()
        let viewNavigationController = UINavigationController(rootViewController: viewController)
        
        window?.rootViewController = viewNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

