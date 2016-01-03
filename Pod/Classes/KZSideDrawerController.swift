//
//  KZSideDrawerController.swift
//  KZSideDrawerController
//
//  Created by Satoshi Matsumoto on 1/3/16.
//  Copyright © 2016 Satoshi Matsumoto. All rights reserved.
//

import UIKit

@objc public enum KZDrawerSide: Int {
    case Left
    case Right
}

@objc public protocol KZSideDrawerControllerDelegate {

    // MARK: - Responding to Side Drawer Controller Events

    optional func sideDrawerController(sideDrawerController: KZSideDrawerController, willOpenViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool)

    optional func sideDrawerController(sideDrawerController: KZSideDrawerController, didOpenViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool)

    optional func sideDrawerController(sideDrawerController: KZSideDrawerController, willCloseViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool)

    optional func sideDrawerController(sideDrawerController: KZSideDrawerController, didCloseViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool)

    // MARK: - Overriding View Rotation Settings

    optional func sideDrawerControllerSupportedInterfaceOrientations(sideDrawerController: KZSideDrawerController) -> UIInterfaceOrientationMask

    optional func sideDrawerControllerPreferredInterfaceOrientationForPresentation(sideDrawerController: KZSideDrawerController) -> UIInterfaceOrientation

}

public class KZSideDrawerController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Drawer View

    private lazy var containerView: KZSideDrawerContainerView = {
        let containerView = KZSideDrawerContainerView()

        containerView.centerContainerView.addGestureRecognizer(self.leftDrawerOpenWithScreenEdgePanGestureRecognizer)
        containerView.centerContainerView.addGestureRecognizer(self.rightDrawerOpenWithScreenEdgePanGestureRecognizer)

        containerView.leftContainerView.addGestureRecognizer(self.leftDrawerCloseOnTapGestureRecognizer)
        containerView.leftContainerView.addGestureRecognizer(self.leftDrawerCloseWithPanGestureRecognizer)
        containerView.leftContainerView.layer.shadowOpacity = self.shadowOpacity
        containerView.leftContainerView.layer.shadowRadius = self.shadowRadius
        containerView.leftContainerView.layer.shadowOffset = self.shadowOffset
        containerView.leftContainerView.layer.shadowColor = self.shadowColor
        containerView.leftContainerView.hidden = true

        containerView.rightContainerView.addGestureRecognizer(self.rightDrawerCloseOnTapGestureRecognizer)
        containerView.rightContainerView.addGestureRecognizer(self.rightDrawerCloseWithPanGestureRecognizer)
        containerView.rightContainerView.layer.shadowOpacity = self.shadowOpacity
        containerView.rightContainerView.layer.shadowRadius = self.shadowRadius
        containerView.rightContainerView.layer.shadowOffset = self.shadowOffset
        containerView.rightContainerView.layer.shadowColor = self.shadowColor
        containerView.rightContainerView.hidden = true

        return containerView
    }()

    // MARK: - Gesture Recognizers

    private lazy var leftDrawerOpenWithScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "didRecognizeScreenEdgePanGesture:")
        gestureRecognizer.delegate = self
        gestureRecognizer.edges = UIRectEdge.Left
        gestureRecognizer.maximumNumberOfTouches = 1
        return gestureRecognizer
    }()

    private lazy var rightDrawerOpenWithScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "didRecognizeScreenEdgePanGesture:")
        gestureRecognizer.delegate = self
        gestureRecognizer.edges = UIRectEdge.Right
        gestureRecognizer.maximumNumberOfTouches = 1
        return gestureRecognizer
    }()

    private lazy var leftDrawerCloseOnTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "didRecognizeTapGesture:")
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()

    private lazy var rightDrawerCloseOnTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "didRecognizeTapGesture:")
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()

    private lazy var leftDrawerCloseWithPanGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "didRecognizePanGesture:")
        gestureRecognizer.delegate = self
        gestureRecognizer.maximumNumberOfTouches = 1
        return gestureRecognizer
    }()

    private lazy var rightDrawerCloseWithPanGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "didRecognizePanGesture:")
        gestureRecognizer.delegate = self
        gestureRecognizer.maximumNumberOfTouches = 1
        return gestureRecognizer
    }()

    // MARK: - State

    private enum State {
        case Open
        case Closed
        case Dragging
        case SettlingOpen
        case SettlingClosed
    }

    private var drawerState: State = .Closed

    private var lastSettledDrawerState: State = .Closed

    private var currentDrawerSide: KZDrawerSide?

    // MARK: - Parameters

    public var leftDrawerWidth: CGFloat {
        get {
            return containerView.leftViewWidth
        }
        set {
            containerView.leftViewWidth = newValue
        }
    }

    public var rightDrawerWidth: CGFloat {
        get {
            return containerView.rightViewWidth
        }
        set {
            containerView.rightViewWidth = newValue
        }
    }

    public var shadowOpacity: Float = 0.5 {
        didSet {
            containerView.leftContainerView.layer.shadowOpacity = shadowOpacity
            containerView.rightContainerView.layer.shadowOpacity = shadowOpacity
        }
    }

    public var shadowRadius: CGFloat = 3 {
        didSet {
            containerView.leftContainerView.layer.shadowRadius = shadowRadius
            containerView.rightContainerView.layer.shadowRadius = shadowRadius
        }
    }

    public var shadowOffset: CGSize = CGSize.zero {
        didSet {
            containerView.leftContainerView.layer.shadowOffset = shadowOffset
            containerView.rightContainerView.layer.shadowOffset = shadowOffset
        }
    }

    public var shadowColor: CGColor = UIColor.blackColor().CGColor {
        didSet {
            containerView.leftContainerView.layer.shadowColor = shadowColor
            containerView.rightContainerView.layer.shadowColor = shadowColor
        }
    }

    private var minimumAnimationDuration: NSTimeInterval = 0.1

    private var minimumAnimationVelocity: CGFloat = 500

    private var animationVelocity: CGFloat = 1000

    private var scrimColor: UIColor = UIColor(white: 0, alpha: 0.3)

    // MARK: - Accessing the Delegate

    public weak var delegate: KZSideDrawerControllerDelegate?

    // MARK: - Child View Controllers

    public var centerViewController: UIViewController? {
        didSet(oldCenterViewController) {
            guard oldCenterViewController != centerViewController else { return }

            replaceCenterViewController(oldCenterViewController, withViewController: centerViewController)
        }
    }

    public var leftViewController: UIViewController? {
        willSet {
            if newValue == nil {
                closeDrawer(side: .Left, animated: false, completion: nil)
            }
        }
        didSet(oldLeftViewController) {
            guard oldLeftViewController != leftViewController else { return }

            replaceSideViewController(oldLeftViewController, withViewController: leftViewController, side: .Left)
        }
    }

    public var rightViewController: UIViewController? {
        willSet {
            if newValue == nil {
                closeDrawer(side: .Right, animated: false, completion: nil)
            }
        }
        didSet(oldRightViewController) {
            guard oldRightViewController != rightViewController else { return }

            replaceSideViewController(oldRightViewController, withViewController: rightViewController, side: .Right)
        }
    }

    // MARK: - Loading a View

    public override func loadView() {
        view = containerView
    }

    // MARK: - Opening and Closing a Drawer

    public func openDrawer(side side: KZDrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        openDrawer(side: side, velocity: animationVelocity, animated: animated, completion: completion)
    }

    private func openDrawer(side side: KZDrawerSide, velocity: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        guard drawerState != .Open else { return }
        guard drawerState != .SettlingOpen else { return }
        guard drawerState != .SettlingClosed else { return }
        guard currentDrawerSide == nil || currentDrawerSide == side else { return }
        guard let sideViewController = sideViewControllerFor(side) else { return }

        let distance: CGFloat
        if side == .Left {
            distance = (1 - containerView.leftViewSlideOffset) * containerView.leftViewWidth
        } else {
            distance = (1 - containerView.rightViewSlideOffset) * containerView.rightViewWidth
        }

        let isClosed: Bool = drawerState == .Closed

        drawerState = .SettlingOpen
        currentDrawerSide = side

        if isClosed  {
            sideViewController.beginAppearanceTransition(true, animated: animated)
            delegate?.sideDrawerController?(self, willOpenViewController: sideViewController, forSide: side, animated: animated)

            sideViewContainerFor(side).hidden = false

            if side == .Left {
                containerView.leftView = sideViewController.view
            } else {
                containerView.rightView = sideViewController.view
            }
            containerView.layoutIfNeeded()
        }

        if side == .Left {
            containerView.leftViewSlideOffset = 1.0
        } else {
            containerView.rightViewSlideOffset = 1.0
        }

        let animations: () -> Void = {
            self.sideViewContainerFor(side).backgroundColor = self.scrimColorFor(side)
            self.setNeedsStatusBarAppearanceUpdate()
            self.containerView.layoutIfNeeded()
        }

        let completionBlock: (Bool) -> Void = { finished in
            self.drawerState = .Open
            self.lastSettledDrawerState = .Open

            self.containerView.userInteractionEnabled = true

            sideViewController.endAppearanceTransition()
            self.delegate?.sideDrawerController?(self, didOpenViewController: sideViewController, forSide: side, animated: animated)

            completion?(finished)
        }

        if (animated) {
            let animationDuration: NSTimeInterval = max(Double(distance) / Double(abs(velocity)), minimumAnimationDuration)

            UIView.animateWithDuration(animationDuration,
                delay: 0,
                options: .CurveEaseInOut,
                animations: animations,
                completion: completionBlock
            )
        } else {
            animations()
            completionBlock(true)
        }
    }

    public func closeDrawer(side side: KZDrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        closeDrawer(side: side, velocity: animationVelocity, animated: animated, completion: completion)
    }

    public func closeDrawer(side side: KZDrawerSide, velocity: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        guard drawerState != .Closed else { return }
        guard drawerState != .SettlingOpen else { return }
        guard drawerState != .SettlingClosed else { return }
        guard currentDrawerSide == side else { return }
        guard let sideViewController = sideViewControllerFor(side) else { return }

        let distance: CGFloat
        if side == .Left {
            distance = containerView.leftViewSlideOffset * containerView.leftViewWidth
        } else {
            distance = containerView.rightViewSlideOffset * containerView.rightViewWidth
        }

        drawerState = .SettlingClosed

        sideViewController.beginAppearanceTransition(false, animated: animated)
        delegate?.sideDrawerController?(self, willCloseViewController: sideViewController, forSide: side, animated: animated)

        if side == .Left {
            containerView.leftViewSlideOffset = 0
        } else {
            containerView.rightViewSlideOffset = 0
        }

        let animations: () -> Void = {
            self.sideViewContainerFor(side).backgroundColor = self.scrimColorFor(side)
            self.setNeedsStatusBarAppearanceUpdate()
            self.containerView.layoutIfNeeded()
        }

        let completionBlock: (Bool) -> Void = { finished in
            self.drawerState = .Closed
            self.lastSettledDrawerState = .Closed
            self.currentDrawerSide = nil

            if side == .Left {
                self.containerView.leftView = nil
            } else {
                self.containerView.rightView = nil
            }

            self.containerView.userInteractionEnabled = true
            self.sideViewContainerFor(side).hidden = true

            sideViewController.endAppearanceTransition()
            self.delegate?.sideDrawerController?(self, didCloseViewController: sideViewController, forSide: side, animated: animated)

            completion?(finished)
        }

        if animated {
            let animationDuration: NSTimeInterval = max(Double(distance) / Double(abs(velocity)), minimumAnimationDuration)

            UIView.animateWithDuration(animationDuration,
                delay: 0,
                options: .CurveEaseInOut,
                animations: animations,
                completion: completionBlock
            )
        } else {
            animations()
            completionBlock(true)
        }
    }

    public func toggleDrawer(side side: KZDrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        switch drawerState {
        case .Closed:
            openDrawer(side: side, animated: animated, completion: completion)
        case .Open where side == currentDrawerSide:
            closeDrawer(side: side, animated: animated, completion: completion)
        default:
            break
        }
    }

    // MARK: - Handling Gesture Recognizers

    final func didRecognizeScreenEdgePanGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard drawerState == .Closed || drawerState == .Dragging else { return }
        guard lastSettledDrawerState == .Closed else { return }

        let side: KZDrawerSide = gestureRecognizer == leftDrawerOpenWithScreenEdgePanGestureRecognizer ? .Left : .Right
        let state: UIGestureRecognizerState = gestureRecognizer.state
        let velocity: CGPoint = gestureRecognizer.velocityInView(containerView)
        let translation: CGPoint = gestureRecognizer.translationInView(containerView)

        guard let sideViewController = sideViewControllerFor(side) else { return }

        switch (state) {
        case .Began:
            drawerState = .Dragging
            currentDrawerSide = side

            sideViewContainerFor(side).hidden = false
            containerView.userInteractionEnabled = false

            if side == .Left {
                containerView.leftView = sideViewController.view
            } else {
                containerView.rightView = sideViewController.view
            }

            sideViewController.beginAppearanceTransition(true, animated: true)
            delegate?.sideDrawerController?(self, willOpenViewController: sideViewController, forSide: side, animated: true)

        case .Changed where drawerState == .Dragging:
            if side == .Left {
                let offset: CGFloat = max(translation.x, 0) / containerView.leftViewWidth
                containerView.leftViewSlideOffset = offset
            } else {
                let offset: CGFloat = -min(translation.x, 0) / containerView.rightViewWidth
                containerView.rightViewSlideOffset = offset
            }

            sideViewContainerFor(side).backgroundColor = scrimColorFor(side)

        case .Ended where drawerState == .Dragging, .Cancelled where drawerState == .Dragging:
            let animationVelocity: CGFloat = max(abs(velocity.x), minimumAnimationVelocity)

            if (velocity.x > 100 && side == .Left) || (velocity.x < -100 && side == .Right) {
                openDrawer(side: side, velocity: animationVelocity, animated: true, completion: nil)
            } else if (velocity.x > 100 && side == .Right) || (velocity.x < -100 && side == .Left) {
                closeDrawer(side: side, velocity: animationVelocity, animated: true, completion: nil)
            } else if slideOffsetFor(side) > 0.5 {
                openDrawer(side: side, velocity: animationVelocity, animated: true, completion: nil)
            } else {
                closeDrawer(side: side, velocity: animationVelocity, animated: true, completion: nil)
            }

        default:
            break
        }
    }

    final func didRecognizeTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        guard drawerState == .Open else { return }

        if gestureRecognizer == leftDrawerCloseOnTapGestureRecognizer {
            closeDrawer(side: .Left, animated: true, completion: nil)
        } else {
            closeDrawer(side: .Right, animated: true, completion: nil)
        }
    }

    final func didRecognizePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard drawerState == .Open || drawerState == .Dragging else { return }
        guard lastSettledDrawerState == .Open else { return }

        let side: KZDrawerSide = gestureRecognizer == leftDrawerCloseWithPanGestureRecognizer ? .Left : .Right
        let state: UIGestureRecognizerState = gestureRecognizer.state
        let location: CGPoint = gestureRecognizer.locationInView(containerView)
        let velocity: CGPoint = gestureRecognizer.velocityInView(containerView)

        guard let sideViewController = sideViewControllerFor(side) else { return }

        if side == .Left && location.x > containerView.leftViewWidth {
            gestureRecognizer.setTranslation(CGPoint.zero, inView: containerView)
        } else if side == .Right && location.x < containerView.frame.width - containerView.rightViewWidth {
            gestureRecognizer.setTranslation(CGPoint.zero, inView: containerView)
        } else if drawerState != .Dragging && (side == .Left && velocity.x < 0 || side == .Right && velocity.x > 0) {
            gestureRecognizer.setTranslation(CGPoint.zero, inView: containerView)

            drawerState = .Dragging

            sideViewController.beginAppearanceTransition(false, animated: true)
            delegate?.sideDrawerController?(self, willCloseViewController: sideViewController, forSide: side, animated: true)

            containerView.userInteractionEnabled = false
        }

        if drawerState != .Dragging {
            return
        }

        let translation: CGPoint = gestureRecognizer.translationInView(containerView)

        switch (state) {
        case .Changed:
            if side == .Left {
                let offset: CGFloat = 1 - -min(translation.x, 0) / containerView.leftViewWidth
                containerView.leftViewSlideOffset = offset
            } else {
                let offset: CGFloat = 1 - max(translation.x, 0) / containerView.rightViewWidth
                containerView.rightViewSlideOffset = offset
            }

            sideViewContainerFor(side).backgroundColor = scrimColorFor(side)

        case .Ended, .Cancelled:
            let animationVelocity: CGFloat = max(abs(velocity.x), minimumAnimationVelocity)

            if (velocity.x > 100 && side == .Left) || (velocity.x < -100 && side == .Right) {
                openDrawer(side: side, velocity: animationVelocity, animated: true, completion: nil)
            } else if (velocity.x > 100 && side == .Right) || (velocity.x < -100 && side == .Left) {
                closeDrawer(side: side, velocity: animationVelocity, animated: true, completion: nil)
            } else if slideOffsetFor(side) > 0.5 {
                openDrawer(side: side, velocity: animationVelocity, animated: true, completion: nil)
            } else {
                closeDrawer(side: side, velocity: animationVelocity, animated: true, completion: nil)
            }

        default:
            break
        }
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        guard drawerState != .SettlingOpen else { return false }
        guard drawerState != .SettlingClosed else { return false }

        switch gestureRecognizer {
        case leftDrawerOpenWithScreenEdgePanGestureRecognizer:
            return leftViewController != nil && lastSettledDrawerState == .Closed
        case rightDrawerOpenWithScreenEdgePanGestureRecognizer:
            return rightViewController != nil && lastSettledDrawerState == .Closed
        case leftDrawerCloseOnTapGestureRecognizer, rightDrawerCloseOnTapGestureRecognizer:
            return touch.view == gestureRecognizer.view && drawerState == .Open
        case leftDrawerCloseWithPanGestureRecognizer, rightDrawerCloseWithPanGestureRecognizer:
            return lastSettledDrawerState == .Open
        default:
            return false
        }
    }

    // MARK: - Managing the Status Bar

    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        if let currentDrawerSide = currentDrawerSide where drawerState == .Open || drawerState == .SettlingOpen {
            return sideViewControllerFor(currentDrawerSide)
        } else {
            return centerViewController
        }
    }

    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        if let currentDrawerSide = currentDrawerSide where drawerState == .Open || drawerState == .SettlingOpen {
            return sideViewControllerFor(currentDrawerSide)
        } else {
            return centerViewController
        }
    }

    // MARK: - Managing Child View Controllers

    public override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return false
    }

    // MARK: - Responding to View Events

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        centerViewController?.beginAppearanceTransition(true, animated: animated)

        if let currentDrawerSide = currentDrawerSide where drawerState != .SettlingClosed {
            sideViewControllerFor(currentDrawerSide)?.beginAppearanceTransition(true, animated: animated)
        }
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        centerViewController?.endAppearanceTransition()

        if let currentDrawerSide = currentDrawerSide where drawerState != .SettlingClosed {
            sideViewControllerFor(currentDrawerSide)?.endAppearanceTransition()
        }
    }

    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        centerViewController?.beginAppearanceTransition(false, animated: animated)

        if let currentDrawerSide = currentDrawerSide where drawerState != .SettlingClosed {
            sideViewControllerFor(currentDrawerSide)?.beginAppearanceTransition(false, animated: animated)
        }
    }

    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        centerViewController?.endAppearanceTransition()

        if let currentDrawerSide = currentDrawerSide where drawerState != .SettlingClosed {
            sideViewControllerFor(currentDrawerSide)?.endAppearanceTransition()
        }
    }

    // MARK: - Configuring the View Rotation Settings

    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let orientations = delegate?.sideDrawerControllerSupportedInterfaceOrientations?(self) {
            return orientations
        } else {
            return super.supportedInterfaceOrientations()
        }
    }

    public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if let orientations = delegate?.sideDrawerControllerPreferredInterfaceOrientationForPresentation?(self) {
            return orientations
        } else {
            return super.preferredInterfaceOrientationForPresentation()
        }
    }

    // MARK: - Helpers

    private func replaceCenterViewController(oldCenterViewController: UIViewController?, withViewController newCenterViewController: UIViewController?) {
        oldCenterViewController?.willMoveToParentViewController(nil)
        if let newCenterViewController = newCenterViewController {
            addChildViewController(newCenterViewController)
        }

        oldCenterViewController?.beginAppearanceTransition(false, animated: false)
        newCenterViewController?.beginAppearanceTransition(true, animated: false)

        containerView.centerView = newCenterViewController?.view

        oldCenterViewController?.endAppearanceTransition()
        newCenterViewController?.endAppearanceTransition()

        oldCenterViewController?.removeFromParentViewController()
        newCenterViewController?.didMoveToParentViewController(self)
    }

    private func replaceSideViewController(oldSideViewController: UIViewController?, withViewController newSideViewController: UIViewController?, side: KZDrawerSide) {
        oldSideViewController?.willMoveToParentViewController(nil)
        if let newSideViewController = newSideViewController {
            addChildViewController(newSideViewController)
        }

        if currentDrawerSide == side && drawerState != .SettlingClosed {
            oldSideViewController?.beginAppearanceTransition(false, animated: false)
            newSideViewController?.beginAppearanceTransition(true, animated: false)

            if side == .Left {
                containerView.leftView = newSideViewController?.view
            } else {
                containerView.rightView = newSideViewController?.view
            }
        }

        if currentDrawerSide == side && drawerState != .SettlingClosed {
            oldSideViewController?.endAppearanceTransition()
            newSideViewController?.endAppearanceTransition()
        }

        oldSideViewController?.removeFromParentViewController()
        newSideViewController?.didMoveToParentViewController(self)
    }

    private func slideOffsetFor(side: KZDrawerSide) -> CGFloat {
        return side == .Left ? containerView.leftViewSlideOffset : containerView.rightViewSlideOffset
    }

    private func sideViewContainerFor(side: KZDrawerSide) -> UIView {
        return side == .Left ? containerView.leftContainerView : containerView.rightContainerView
    }

    private func sideViewControllerFor(side: KZDrawerSide) -> UIViewController? {
        return side == .Left ? leftViewController : rightViewController
    }

    private func scrimColorFor(side: KZDrawerSide) -> UIColor {
        return scrimColor.colorWithAlphaComponent(CGColorGetAlpha(scrimColor.CGColor) * slideOffsetFor(side))
    }

}