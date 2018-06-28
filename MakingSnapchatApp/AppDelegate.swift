//
//  AppDelegate.swift
//  MakingSnapchatApp
//
//  Created by Victor Hyde on 27/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Launch our master view controller
        let master = MasterViewController()
        window = UIWindow()
        window?.rootViewController = master
        window?.makeKeyAndVisible()

        return true
    }

}

