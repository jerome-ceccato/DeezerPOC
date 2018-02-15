//
//  AppDelegate.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        createRootController()
        return true
    }
}

private extension AppDelegate {
    func createRootController() {
        let exampleUserID = "5"
        let service = UserPlaylistsService(userID: exampleUserID)
        let viewModel = UserPlaylistsViewModel(service: service)
        let controller = UserPlaylistsViewController.instanciate(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: controller)
        setKeyWindow(withRootViewController: navigationController)
    }
    
    func setKeyWindow(withRootViewController rootViewController: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
