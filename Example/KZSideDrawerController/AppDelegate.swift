//
//  AppDelegate.swift
//  KZSideDrawerController
//
//  Created by Satoshi Matsumoto on 1/3/16.
//  Copyright © 2016 Satoshi Matsumoto. All rights reserved.
//

import UIKit
import KZSideDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var centerViewController: UIViewController = {
        UINavigationController(rootViewController: self.drawerSettingsViewController)
    }()

    private let leftViewController: UIViewController = {
        let viewController = ExampleViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()

    private let rightViewController: UIViewController = {
        let viewController = ExampleViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }()

    private lazy var drawerSettingsViewController: UIViewController = DrawerSettingsViewController(style: .Grouped)

    private lazy var drawerController: KZSideDrawerController = {
        let drawerController = KZSideDrawerController()

        drawerController.delegate = self

        drawerController.centerViewController = self.centerViewController
        drawerController.leftViewController = self.leftViewController
        drawerController.rightViewController = self.rightViewController

        return drawerController
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: KZSideDrawerControllerDelegate {

    func sideDrawerController(sideDrawerController: KZSideDrawerController, willOpenViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {
        print("willOpenViewController")
    }

    func sideDrawerController(sideDrawerController: KZSideDrawerController, didOpenViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {
        print("didOpenViewController")
    }

    func sideDrawerController(sideDrawerController: KZSideDrawerController, willCloseViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {
        print("willCloseViewController")
    }

    func sideDrawerController(sideDrawerController: KZSideDrawerController, didCloseViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {
        print("didCloseViewController")
    }

}