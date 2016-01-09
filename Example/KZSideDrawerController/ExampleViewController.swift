//
//  ExampleViewController.swift
//  KZSideDrawerController
//
//  Created by Satoshi Matsumoto on 1/3/16.
//  Copyright © 2016 Satoshi Matsumoto. All rights reserved.
//

import UIKit
import KZSideDrawerController

class ExampleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private enum Position {
        case Center
        case Left
        case Right
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private var drawerController: KZSideDrawerController? {
        for var viewController = parentViewController; viewController != nil; viewController = viewController?.parentViewController {
            if let drawerController = viewController as? KZSideDrawerController {
                return drawerController
            }
        }
        return nil
    }

    private var centerViewController: UIViewController? {
        return drawerController?.centerViewController
    }

    private var leftViewController: UIViewController? {
        return drawerController?.leftViewController
    }

    private var rightViewController: UIViewController? {
        return drawerController?.rightViewController
    }

    private var position: Position? {
        let viewController = parentViewController ?? self
        if viewController == centerViewController {
            return .Center
        } else if viewController == leftViewController {
            return .Left
        } else if viewController == rightViewController {
            return .Right
        }
        return nil
    }

    private var drawerSide: KZDrawerSide? {
        if position == .Left {
            return .Left
        } else if position == .Right {
            return .Right
        }
        return nil
    }

    private var pageViewController: UIPageViewController? {
        for var viewController = parentViewController; viewController != nil; viewController = viewController?.parentViewController {
            if let pageViewController = viewController as? UIPageViewController {
                return pageViewController
            }
        }
        return nil
    }

    private var statusBarStyle: UIStatusBarStyle = .Default

    private var statusBarHidden: Bool = false

    private var statusBarUpdateAnimation: UIStatusBarAnimation = .Fade

    private var nextStatusBarStyle: UIStatusBarStyle {
        let rawValue: Int = (statusBarStyle.rawValue + 1) % (UIStatusBarStyle.LightContent.rawValue + 1)
        return UIStatusBarStyle(rawValue: rawValue)!
    }

    private var nextStatusBarUpdateAnimation: UIStatusBarAnimation {
        let rawValue: Int = (statusBarUpdateAnimation.rawValue + 1) % (UIStatusBarAnimation.Slide.rawValue + 1)
        return UIStatusBarAnimation(rawValue: rawValue)!
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }

    override func prefersStatusBarHidden() -> Bool {
        return statusBarHidden
    }

    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return statusBarUpdateAnimation
    }

    override func loadView() {
        view = tableView
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.frame.origin.y = UIApplication.sharedApplication().statusBarFrame.height

        print("viewWillAppear")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        print("viewDidAppear")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        print("viewWillDisappear")
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        print("viewDidDisappear")
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row == 0 {
            cell.textLabel?.text = "pushViewController(_:animated:)"
            cell.accessoryType = .DisclosureIndicator
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "setNavigationBarHidden(_:animated:)"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "setToolbarHidden(_:animated:)"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "preferredStatusBarStyle"
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "prefersStatusBarHidden"
        } else if indexPath.row == 5 {
            cell.textLabel?.text = "preferredStatusBarUpdateAnimation"
        } else if indexPath.row == 6 {
            cell.textLabel?.text = "UINavigationController"
        } else if indexPath.row == 7 {
            cell.textLabel?.text = "UISplitViewController"
        } else if indexPath.row == 8 {
            cell.textLabel?.text = "UITabBarController"
        } else if indexPath.row == 9 {
            cell.textLabel?.text = "UIPageViewController"
        } else if indexPath.row == 10 {
            cell.textLabel?.text = "UIStoryboard"
        } else if indexPath.row == 11 {
            cell.textLabel?.text = "toggleDrawer(side:animated:)"
        } else if indexPath.row == 12 {
            cell.textLabel?.text = "centerViewController"
        } else if indexPath.row == 13 {
            cell.textLabel?.text = "leftViewController"
        } else {
            cell.textLabel?.text = "rightViewController"
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let viewController = ExampleViewController2()
            navigationController?.pushViewController(viewController, animated: true)
        } else if indexPath.row == 1 {
            if let navigationController = navigationController {
                navigationController.setNavigationBarHidden(!navigationController.navigationBarHidden, animated: true)
            }
        } else if indexPath.row == 2 {
            if let navigationController = navigationController {
                navigationController.setToolbarHidden(!navigationController.toolbarHidden, animated: true)
            }
        } else if indexPath.row == 3 {
            statusBarStyle = nextStatusBarStyle
            UIView.animateWithDuration(0.2) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        } else if indexPath.row == 4 {
            statusBarHidden = !statusBarHidden
            UIView.animateWithDuration(0.2) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        } else if indexPath.row == 5 {
            statusBarUpdateAnimation = nextStatusBarUpdateAnimation
        } else if indexPath.row == 6 {
            if let drawerController = drawerController, position = position {
                detacheViewControllerAt(position, drawerController: drawerController)
                let viewController = UINavigationController(rootViewController: ExampleViewController())
                replaceViewControllerAt(position, with: viewController, drawerController: drawerController)
            }
        } else if indexPath.row == 7 {
            if let drawerController = drawerController, position = position {
                detacheViewControllerAt(position, drawerController: drawerController)
                let viewController = UISplitViewController()
                viewController.viewControllers = [ExampleViewController()]
                replaceViewControllerAt(position, with: viewController, drawerController: drawerController)
            }
        } else if indexPath.row == 8 {
            if let drawerController = drawerController, position = position {
                detacheViewControllerAt(position, drawerController: drawerController)
                let viewController = UITabBarController()
                viewController.viewControllers = [ExampleViewController()]
                replaceViewControllerAt(position, with: viewController, drawerController: drawerController)
            }
        } else if indexPath.row == 9 {
            if let drawerController = drawerController, position = position {
                detacheViewControllerAt(position, drawerController: drawerController)
                let viewController = UIPageViewController()
                viewController.setViewControllers([ExampleViewController()], direction: .Forward, animated: false, completion: nil)
                replaceViewControllerAt(position, with: viewController, drawerController: drawerController)
            }
        } else if indexPath.row == 10 {
            let centerViewController: UIViewController? = drawerController?.centerViewController
            let leftViewController: UIViewController? = drawerController?.leftViewController
            let rightViewController: UIViewController? = drawerController?.rightViewController
            let drawerControllerDelegate: KZSideDrawerControllerDelegate? = drawerController?.delegate

            drawerController?.centerViewController = nil
            drawerController?.leftViewController = nil
            drawerController?.rightViewController = nil

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newDrawerController = storyboard.instantiateViewControllerWithIdentifier("SideDrawerController") as! KZSideDrawerController

            newDrawerController.centerViewController = centerViewController
            newDrawerController.leftViewController = leftViewController
            newDrawerController.rightViewController = rightViewController
            newDrawerController.delegate = drawerControllerDelegate

            let window: UIWindow? = UIApplication.sharedApplication().delegate?.window ?? nil
            window?.rootViewController = newDrawerController
            window?.makeKeyAndVisible()
        } else if indexPath.row == 11 {
            drawerController?.toggleDrawer(side: drawerSide ?? .Left, animated: true) { finished in
                if finished {
                    print("toggleDrawer finished")
                }
            }
        } else if indexPath.row == 12 {
            if let drawerController = drawerController, position = position where position != .Center {
                swapViewControllerAt(position, forViewControllerAt: .Center, drawerController: drawerController)
            }
        } else if indexPath.row == 13 {
            if let drawerController = drawerController, position = position where position != .Left {
                swapViewControllerAt(position, forViewControllerAt: .Left, drawerController: drawerController)
            }
        } else {
            if let drawerController = drawerController, position = position where position != .Right {
                swapViewControllerAt(position, forViewControllerAt: .Right, drawerController: drawerController)
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    private func detacheViewControllerAt(position: Position, drawerController: KZSideDrawerController) {
        replaceViewControllerAt(position, with: nil, drawerController: drawerController)
        navigationController?.viewControllers = []
        splitViewController?.viewControllers = []
        tabBarController?.viewControllers = nil
        pageViewController?.setViewControllers(nil, direction: .Forward, animated: false, completion: nil)
    }

    private func replaceViewControllerAt(position: Position, with newViewController: UIViewController?, drawerController: KZSideDrawerController) -> UIViewController? {
        let oldViewController: UIViewController?
        switch position {
        case .Center:
            oldViewController = drawerController.centerViewController
            drawerController.centerViewController = newViewController
        case .Left:
            oldViewController = drawerController.leftViewController
            drawerController.leftViewController = newViewController
        case .Right:
            oldViewController = drawerController.rightViewController
            drawerController.rightViewController = newViewController
        }
        return oldViewController
    }

    private func swapViewControllerAt(position1: Position, forViewControllerAt position2: Position, drawerController: KZSideDrawerController) {
        let viewController1: UIViewController? = replaceViewControllerAt(position1, with: nil, drawerController: drawerController)
        let viewController2: UIViewController? = replaceViewControllerAt(position2, with: viewController1, drawerController: drawerController)
        replaceViewControllerAt(position1, with: viewController2, drawerController: drawerController)
    }

}

class ExampleViewController2: UITableViewController {

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "popViewControllerAnimated:"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.popViewControllerAnimated(true)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}