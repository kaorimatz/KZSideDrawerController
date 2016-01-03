//
//  DrawerSettingsViewController.swift
//  KZSideDrawerController
//
//  Created by Satoshi Matsumoto on 1/3/16.
//  Copyright © 2016 Satoshi Matsumoto. All rights reserved.
//

import UIKit
import KZSideDrawerController
import PureLayout

class DrawerSettingsViewController: UITableViewController {

    // MARK: - Drawer Controller

    private var drawerController: KZSideDrawerController? {
        return navigationController?.parentViewController as? KZSideDrawerController
    }

    private var drawerLeftViewController: UIViewController?

    private var drawerRightViewController: UIViewController?

    // MARK: - Shadow Opacity

    private var shadowOpacity: Float {
        return drawerController?.shadowOpacity ?? 0
    }

    private lazy var shadowOpacityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSString(format: "%.2f", self.shadowOpacity) as String
        return label
    }()

    private lazy var shadowOpacitySlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = self.shadowOpacity
        slider.addTarget(self, action: "didChangeShadowOpacity:", forControlEvents: .ValueChanged)
        return slider
    }()

    private lazy var shadowOpacityCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.selectionStyle = .None
        cell.contentView.addSubview(self.shadowOpacityLabel)
        cell.contentView.addSubview(self.shadowOpacitySlider)
        self.shadowOpacityLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Right)
        self.shadowOpacityLabel.autoSetDimension(.Width, toSize: 40)
        self.shadowOpacitySlider.autoPinEdgesToSuperviewMarginsExcludingEdge(.Left)
        self.shadowOpacitySlider.autoPinEdge(.Left, toEdge: .Right, ofView: self.shadowOpacityLabel, withOffset: 8)
        return cell
    }()

    func didChangeShadowOpacity(sender: UISlider) {
        drawerController?.shadowOpacity = sender.value
        shadowOpacityLabel.text = NSString(format: "%.2f", shadowOpacity) as String
    }

    // MARK: - Left Drawer

    private var leftDrawerEnabled: Bool {
        return drawerController?.leftViewController != nil
    }

    private lazy var leftDrawerEnabledSwitch: UISwitch = {
        let enabledSwitch = UISwitch()
        enabledSwitch.translatesAutoresizingMaskIntoConstraints = false
        enabledSwitch.on = self.leftDrawerEnabled
        enabledSwitch.addTarget(self, action: "didChangeLeftDrawerEnabled:", forControlEvents: .ValueChanged)
        return enabledSwitch
    }()

    private lazy var leftDrawerEnabledCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.selectionStyle = .None
        cell.contentView.addSubview(self.leftDrawerEnabledSwitch)
        self.leftDrawerEnabledSwitch.autoCenterInSuperview()
        return cell
    }()

    func didChangeLeftDrawerEnabled(sender: UISwitch) {
        if sender.on {
            drawerController?.leftViewController = drawerLeftViewController
        } else {
            drawerLeftViewController = drawerController?.leftViewController
            drawerController?.leftViewController = nil
        }
    }

    // MARK: - Right Drawer

    private var rightDrawerEnabled: Bool {
        return drawerController?.rightViewController != nil
    }

    private lazy var rightDrawerEnabledSwitch: UISwitch = {
        let enabledSwitch = UISwitch()
        enabledSwitch.translatesAutoresizingMaskIntoConstraints = false
        enabledSwitch.on = self.rightDrawerEnabled
        enabledSwitch.addTarget(self, action: "didChangeRightDrawerEnabled:", forControlEvents: .ValueChanged)
        return enabledSwitch
    }()

    private lazy var rightDrawerEnabledCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.selectionStyle = .None
        cell.contentView.addSubview(self.rightDrawerEnabledSwitch)
        self.rightDrawerEnabledSwitch.autoCenterInSuperview()
        return cell
    }()

    func didChangeRightDrawerEnabled(sender: UISwitch) {
        if sender.on {
            drawerController?.rightViewController = drawerRightViewController
        } else {
            drawerRightViewController = drawerController?.rightViewController
            drawerController?.rightViewController = nil
        }
    }

    // MARK: - Left Drawer Width

    private var leftDrawerWidth: CGFloat {
        return drawerController?.leftDrawerWidth ?? 0
    }

    private lazy var leftDrawerWidthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSString(format: "%.f", self.leftDrawerWidth) as String
        return label
    }()

    private lazy var leftDrawerWidthSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = Float(self.view.frame.width)
        slider.value = Float(self.leftDrawerWidth)
        slider.addTarget(self, action: "didChangeLeftDrawerWidth:", forControlEvents: .ValueChanged)
        return slider
    }()

    private lazy var leftDrawerWidthCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.selectionStyle = .None
        cell.contentView.addSubview(self.leftDrawerWidthLabel)
        cell.contentView.addSubview(self.leftDrawerWidthSlider)
        self.leftDrawerWidthLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Right)
        self.leftDrawerWidthLabel.autoSetDimension(.Width, toSize: 40)
        self.leftDrawerWidthSlider.autoPinEdgesToSuperviewMarginsExcludingEdge(.Left)
        self.leftDrawerWidthSlider.autoPinEdge(.Left, toEdge: .Right, ofView: self.leftDrawerWidthLabel, withOffset: 8)
        return cell
    }()

    func didChangeLeftDrawerWidth(sender: UISlider) {
        drawerController?.leftDrawerWidth = CGFloat(sender.value)
        leftDrawerWidthLabel.text = NSString(format: "%.f", leftDrawerWidth) as String
    }

    // MARK: - Right Drawer Width

    private var rightDrawerWidth: CGFloat {
        return drawerController?.rightDrawerWidth ?? 0
    }

    private lazy var rightDrawerWidthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSString(format: "%.f", self.rightDrawerWidth) as String
        return label
    }()

    private lazy var rightDrawerWidthSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = Float(self.view.frame.width)
        slider.value = Float(self.rightDrawerWidth)
        slider.addTarget(self, action: "didChangeRightDrawerWidth:", forControlEvents: .ValueChanged)
        return slider
    }()

    private lazy var rightDrawerWidthCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.selectionStyle = .None
        cell.contentView.addSubview(self.rightDrawerWidthLabel)
        cell.contentView.addSubview(self.rightDrawerWidthSlider)
        self.rightDrawerWidthLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Right)
        self.rightDrawerWidthLabel.autoSetDimension(.Width, toSize: 40)
        self.rightDrawerWidthSlider.autoPinEdgesToSuperviewMarginsExcludingEdge(.Left)
        self.rightDrawerWidthSlider.autoPinEdge(.Left, toEdge: .Right, ofView: self.rightDrawerWidthLabel, withOffset: 8)
        return cell
    }()

    func didChangeRightDrawerWidth(sender: UISlider) {
        drawerController?.rightDrawerWidth = CGFloat(sender.value)
        rightDrawerWidthLabel.text = NSString(format: "%.f", rightDrawerWidth) as String
    }

    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()

        let menuImage = UIImage(named: "ic_menu")

        let leftMenuButtonItem = UIBarButtonItem(image: menuImage, style: .Plain, target: self, action: "didTapLeftMenuButtonItem:")
        navigationItem.leftBarButtonItem = leftMenuButtonItem

        let rightMenuButtonItem = UIBarButtonItem(image: menuImage, style: .Plain, target: self, action: "didTapRightMenuButtonItem:")
        navigationItem.rightBarButtonItem = rightMenuButtonItem
    }

    // MARK: - Configuring a Table View

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return shadowOpacityCell
        } else if indexPath.section == 1 {
            return leftDrawerEnabledCell
        } else if indexPath.section == 2 {
            return rightDrawerEnabledCell
        } else if indexPath.section == 3 {
            return leftDrawerWidthCell
        } else {
            return rightDrawerWidthCell
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Shadow opacity"
        } else if section == 1 {
            return "Left drawer"
        } else if section == 2 {
            return "Right drawer"
        } else if section == 3 {
            return "Left drawer width"
        } else {
            return "Right drawer width"
        }
    }

    // MARK: - Handling the Menu Button

    func didTapLeftMenuButtonItem(_: UIBarButtonItem) {
        drawerController?.openDrawer(side: .Left, animated: true) { finished in
            if finished {
                print("openDrawer finished")
            }
        }
    }

    func didTapRightMenuButtonItem(_: UIBarButtonItem) {
        drawerController?.openDrawer(side: .Right, animated: true) { finished in
            if finished {
                print("openDrawer finished")
            }
        }
    }

}
