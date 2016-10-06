//
//  KZSideDrawerController.swift
//  KZSideDrawerController
//
//  Created by Satoshi Matsumoto on 1/3/16.
//  Copyright © 2016 Satoshi Matsumoto. All rights reserved.
//

import UIKit

/// Constants that specify the side of a drawer.
@objc public enum KZDrawerSide: Int {
    case left
    case right
}

/// The `KZSideDrawerControllerDelegate` protocol defines optional methods for a delegate of a `KZSideDrawerController` object.
@objc public protocol KZSideDrawerControllerDelegate {

    // MARK: - Responding to Side Drawer Controller Events

    /// Tells the delegate that the drawer is about to be opened.
    ///
    /// - parameter sideDrawerController: The side drawer controller.
    /// - parameter viewController: The view controller whose drawer view is about to be opened.
    /// - parameter side: The side of the drawer that will be opened.
    /// - parameter animated: `true` if the opening will be animated, otherwise `false`.
    @objc optional func sideDrawerController(_ sideDrawerController: KZSideDrawerController, willOpenViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool)

    /// Tells the delegate that the drawer was opened.
    ///
    /// - parameter sideDrawerController: The side drawer controller.
    /// - parameter viewController: The view controller whose drawer view was opened.
    /// - parameter side: The side of the drawer that was opened.
    /// - parameter animated: `true` if the opening was animated, otherwise `false`.
    @objc optional func sideDrawerController(_ sideDrawerController: KZSideDrawerController, didOpenViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool)

    /// Tells the delegate that the drawer is about to be closed.
    ///
    /// - parameter sideDrawerController: The side drawer controller.
    /// - parameter viewController: The view controller whose drawer view is about to be closed.
    /// - parameter side: The side of the drawer that will be closed.
    /// - parameter animated: `true` if the closing will be animated, otherwise `false`.
    @objc optional func sideDrawerController(_ sideDrawerController: KZSideDrawerController, willCloseViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool)

    /// Tells the delegate that the drawer was closed.
    ///
    /// - parameter sideDrawerController: The side drawer controller.
    /// - parameter viewController: The view controller whose drawer view was closed.
    /// - parameter side: The side of the drawer that was closed.
    /// - parameter animated: `true` if the closing was animated, otherwise `false`.
    @objc optional func sideDrawerController(_ sideDrawerController: KZSideDrawerController, didCloseViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool)

    // MARK: - Overriding View Rotation Settings

    /// Asks the delegate for the interface orientations that the side drawer controller supports.
    ///
    /// - parameter sideDrawerController: The side drawer controller.
    /// - returns: The bit mask specifying the interface orientations that the side drawer controller supports.
    @objc optional func sideDrawerControllerSupportedInterfaceOrientations(_ sideDrawerController: KZSideDrawerController) -> UIInterfaceOrientationMask

    /// Asks the delegate for the preferred interface orientation to use when presenting the side drawer controller
    ///
    /// - parameter sideDrawerController: The side drawer controller.
    /// - returns: The preferred interface orientation to use when presenting the side drawer controller.
    @objc optional func sideDrawerControllerPreferredInterfaceOrientationForPresentation(_ sideDrawerController: KZSideDrawerController) -> UIInterfaceOrientation

}

/// The `KZSideDrawerController` class is a container view controller that manages drawer views.
open class KZSideDrawerController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Container View

    fileprivate lazy var containerView: KZSideDrawerContainerView = {
        let containerView = KZSideDrawerContainerView()

        containerView.centerContainerView.addGestureRecognizer(self.leftDrawerOpenWithScreenEdgePanGestureRecognizer)
        containerView.centerContainerView.addGestureRecognizer(self.rightDrawerOpenWithScreenEdgePanGestureRecognizer)

        containerView.leftContainerView.addGestureRecognizer(self.leftDrawerCloseOnTapGestureRecognizer)
        containerView.leftContainerView.addGestureRecognizer(self.leftDrawerCloseWithPanGestureRecognizer)
        containerView.leftWrapperView.layer.shadowOpacity = self.shadowOpacity
        containerView.leftWrapperView.layer.shadowRadius = self.shadowRadius
        containerView.leftWrapperView.layer.shadowOffset = self.shadowOffset
        containerView.leftWrapperView.layer.shadowColor = self.shadowColor.cgColor
        containerView.leftContainerView.isHidden = true

        containerView.rightContainerView.addGestureRecognizer(self.rightDrawerCloseOnTapGestureRecognizer)
        containerView.rightContainerView.addGestureRecognizer(self.rightDrawerCloseWithPanGestureRecognizer)
        containerView.rightWrapperView.layer.shadowOpacity = self.shadowOpacity
        containerView.rightWrapperView.layer.shadowRadius = self.shadowRadius
        containerView.rightWrapperView.layer.shadowOffset = self.shadowOffset
        containerView.rightWrapperView.layer.shadowColor = self.shadowColor.cgColor
        containerView.rightContainerView.isHidden = true

        return containerView
    }()

    // MARK: - Gesture Recognizers

    /// The gesture recognizer used to open the left drawer from the left edge of the screen.
    open fileprivate(set) lazy var leftDrawerOpenWithScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(KZSideDrawerController.didRecognizeScreenEdgePanGesture(_:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.edges = UIRectEdge.left
        gestureRecognizer.maximumNumberOfTouches = 1
        return gestureRecognizer
    }()

    /// The gesture recognizer used to open the right drawer from the right edge of the screen.
    open fileprivate(set) lazy var rightDrawerOpenWithScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(KZSideDrawerController.didRecognizeScreenEdgePanGesture(_:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.edges = UIRectEdge.right
        gestureRecognizer.maximumNumberOfTouches = 1
        return gestureRecognizer
    }()

    /// The gesture recognizer used to close the left drawer.
    open fileprivate(set) lazy var leftDrawerCloseOnTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(KZSideDrawerController.didRecognizeTapGesture(_:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()

    /// The gesture recognizer used to close the right drawer.
    open fileprivate(set) lazy var rightDrawerCloseOnTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(KZSideDrawerController.didRecognizeTapGesture(_:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()

    /// The gesture recognizer used to interactively close the left drawer.
    open fileprivate(set) lazy var leftDrawerCloseWithPanGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(KZSideDrawerController.didRecognizePanGesture(_:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.maximumNumberOfTouches = 1
        return gestureRecognizer
    }()

    /// The gesture recognizer used to interactively close the right drawer.
    open fileprivate(set) lazy var rightDrawerCloseWithPanGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(KZSideDrawerController.didRecognizePanGesture(_:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.maximumNumberOfTouches = 1
        return gestureRecognizer
    }()

    // MARK: - State

    fileprivate enum State {
        case open
        case closed
        case dragging
        case settlingOpen
        case settlingClosed
    }

    fileprivate var drawerState: State = .closed

    fileprivate var lastSettledDrawerState: State = .closed

    fileprivate var currentDrawerSide: KZDrawerSide?

    // MARK: - Parameters

    /// The width of the left drawer.
    @IBInspectable open var leftDrawerWidth: CGFloat {
        get {
            return containerView.leftViewWidth
        }
        set {
            containerView.leftViewWidth = newValue
        }
    }

    /// The width of the right drawer.
    @IBInspectable open var rightDrawerWidth: CGFloat {
        get {
            return containerView.rightViewWidth
        }
        set {
            containerView.rightViewWidth = newValue
        }
    }

    /// The opacity of the drawer's shadow.
    @IBInspectable open var shadowOpacity: Float = 0.5 {
        didSet {
            containerView.leftWrapperView.layer.shadowOpacity = shadowOpacity
            containerView.rightWrapperView.layer.shadowOpacity = shadowOpacity
        }
    }

    /// The blur radius of the drawer's shadow.
    @IBInspectable open var shadowRadius: CGFloat = 3 {
        didSet {
            containerView.leftWrapperView.layer.shadowRadius = shadowRadius
            containerView.rightWrapperView.layer.shadowRadius = shadowRadius
        }
    }

    /// The offset of the drawer's shadow.
    @IBInspectable open var shadowOffset: CGSize = CGSize.zero {
        didSet {
            containerView.leftWrapperView.layer.shadowOffset = shadowOffset
            containerView.rightWrapperView.layer.shadowOffset = shadowOffset
        }
    }

    /// The color of the drawer's shadow.
    @IBInspectable open var shadowColor: UIColor = UIColor.black {
        didSet {
            containerView.leftWrapperView.layer.shadowColor = shadowColor.cgColor
            containerView.rightWrapperView.layer.shadowColor = shadowColor.cgColor
        }
    }

    /// The color used to dim the center view while the drawer is open.
    @IBInspectable open var dimmingColor: UIColor = UIColor(white: 0, alpha: 0.3) {
        didSet {
            containerView.leftContainerView.backgroundColor = dimmingColorFor(.left)
            containerView.rightContainerView.backgroundColor = dimmingColorFor(.right)
        }
    }

    fileprivate var minimumAnimationDuration: TimeInterval = 0.1

    fileprivate var minimumAnimationVelocity: CGFloat = 500

    fileprivate var animationVelocity: CGFloat = 1000

    // MARK: - Accessing the Delegate

    /// The delegate of the side drawer controller.
    open weak var delegate: KZSideDrawerControllerDelegate?

    // MARK: - Child View Controllers

    /// The center view controller.
    open var centerViewController: UIViewController? {
        didSet(oldCenterViewController) {
            guard oldCenterViewController != centerViewController else { return }

            replaceCenterViewController(oldCenterViewController, withViewController: centerViewController)
        }
    }

    /// The left view controller.
    open var leftViewController: UIViewController? {
        willSet {
            if newValue == nil {
                closeDrawer(.left, animated: false, completion: nil)
            }
        }
        didSet(oldLeftViewController) {
            guard oldLeftViewController != leftViewController else { return }

            replaceSideViewController(oldLeftViewController, withViewController: leftViewController, side: .left)
        }
    }

    /// The right view controller.
    open var rightViewController: UIViewController? {
        willSet {
            if newValue == nil {
                closeDrawer(.right, animated: false, completion: nil)
            }
        }
        didSet(oldRightViewController) {
            guard oldRightViewController != rightViewController else { return }

            replaceSideViewController(oldRightViewController, withViewController: rightViewController, side: .right)
        }
    }

    // MARK: - Loading a View

    open override func loadView() {
        view = containerView
    }

    // MARK: - Opening and Closing a Drawer

    /// Open the drawer.
    ///
    /// - parameter side: The side of the drawer to be opended.
    /// - parameter animated: Specify `true` to animate the opening of the drawer or `false` to open it immediately.
    /// - parameter completion: The block to be called when the opening finishes.
    open func openDrawer(_ side: KZDrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        openDrawer(side, velocity: animationVelocity, animated: animated, completion: completion)
    }

    fileprivate func openDrawer(_ side: KZDrawerSide, velocity: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        guard let sideViewController = sideViewControllerFor(side) , canOpenDrawerFor(side) else {
            completion?(false)
            return
        }

        let distance: CGFloat
        if side == .left {
            distance = (1 - containerView.leftViewSlideOffset) * containerView.leftViewWidth
        } else {
            distance = (1 - containerView.rightViewSlideOffset) * containerView.rightViewWidth
        }

        let sideViewContainer: UIView = sideViewContainerFor(side)
        let closed: Bool = drawerState == .closed
        let dragging: Bool = drawerState == .dragging

        drawerState = .settlingOpen
        currentDrawerSide = side

        if !(dragging && lastSettledDrawerState == .closed) {
            willOpenViewController(sideViewController, forSide: side, animated: animated)
        }

        if closed {
            sideViewContainer.isHidden = false

            if side == .left {
                containerView.leftView = sideViewController.view
            } else {
                containerView.rightView = sideViewController.view
            }
            containerView.layoutIfNeeded()
        }

        if side == .left {
            containerView.leftViewSlideOffset = 1.0
        } else {
            containerView.rightViewSlideOffset = 1.0
        }

        if #available(iOS 8, *) {
            // No need to update constraints here in iOS 8 or later
        } else {
            containerView.updateConstraintsIfNeeded()
        }

        let animations: () -> Void = {
            sideViewContainer.backgroundColor = self.dimmingColorFor(side)
            self.setNeedsStatusBarAppearanceUpdate()
            self.containerView.layoutIfNeeded()
        }

        let completionBlock: (Bool) -> Void = { finished in
            self.drawerState = .open
            self.lastSettledDrawerState = .open

            self.containerView.isUserInteractionEnabled = true

            self.didOpenViewController(sideViewController, forSide: side, animated: animated)

            completion?(finished)
        }

        if (animated) {
            let animationDuration: TimeInterval = max(Double(distance) / Double(abs(velocity)), minimumAnimationDuration)

            UIView.animate(withDuration: animationDuration,
                                       delay: 0,
                                       options: .curveEaseInOut,
                                       animations: animations,
                                       completion: completionBlock
            )
        } else {
            animations()
            completionBlock(true)
        }
    }

    fileprivate func canOpenDrawerFor(_ side: KZDrawerSide) -> Bool {
        return drawerState != .open &&
            drawerState != .settlingOpen &&
            drawerState != .settlingClosed &&
            (currentDrawerSide == nil || currentDrawerSide == side)
    }

    /// Close the drawer.
    ///
    /// - parameter side: The side of the drawer to be closed.
    /// - parameter animated: Specify `true` to animate the closing of the drawer or `false` to close it immediately.
    /// - parameter completion: The block to be called when the closing finishes.
    open func closeDrawer(_ side: KZDrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        closeDrawer(side, velocity: animationVelocity, animated: animated, completion: completion)
    }

    fileprivate func closeDrawer(_ side: KZDrawerSide, velocity: CGFloat, animated: Bool, completion: ((Bool) -> Void)?) {
        guard let sideViewController = sideViewControllerFor(side) , canCloseDrawerFor(side) else {
            completion?(false)
            return
        }

        let distance: CGFloat
        if side == .left {
            distance = containerView.leftViewSlideOffset * containerView.leftViewWidth
        } else {
            distance = containerView.rightViewSlideOffset * containerView.rightViewWidth
        }

        let sideViewContainer: UIView = sideViewContainerFor(side)
        let dragging: Bool = drawerState == .dragging

        drawerState = .settlingClosed

        if !(dragging && lastSettledDrawerState == .open) {
            willCloseViewController(sideViewController, forSide: side, animated: animated)
        }

        if side == .left {
            containerView.leftViewSlideOffset = 0
        } else {
            containerView.rightViewSlideOffset = 0
        }

        if #available(iOS 8, *) {
            // No need to update constraints here in iOS 8 or later
        } else {
            containerView.updateConstraintsIfNeeded()
        }

        let animations: () -> Void = {
            sideViewContainer.backgroundColor = self.dimmingColorFor(side)
            self.setNeedsStatusBarAppearanceUpdate()
            self.containerView.layoutIfNeeded()
        }

        let completionBlock: (Bool) -> Void = { finished in
            self.drawerState = .closed
            self.lastSettledDrawerState = .closed
            self.currentDrawerSide = nil

            if side == .left {
                self.containerView.leftView = nil
            } else {
                self.containerView.rightView = nil
            }

            self.containerView.isUserInteractionEnabled = true
            sideViewContainer.isHidden = true

            self.didCloseViewController(sideViewController, forSide: side, animated: animated)

            completion?(finished)
        }

        if animated {
            let animationDuration: TimeInterval = max(Double(distance) / Double(abs(velocity)), minimumAnimationDuration)

            UIView.animate(withDuration: animationDuration,
                                       delay: 0,
                                       options: .curveEaseInOut,
                                       animations: animations,
                                       completion: completionBlock
            )
        } else {
            animations()
            completionBlock(true)
        }
    }

    fileprivate func canCloseDrawerFor(_ side: KZDrawerSide) -> Bool {
        return drawerState != .closed &&
            drawerState != .settlingOpen &&
            drawerState != .settlingClosed &&
            currentDrawerSide == side
    }

    /// Toggle the drawer.
    ///
    /// - parameter side: The side of the drawer to be opened/closed.
    /// - parameter animated: Specify `true` to animate the opening/closing of the drawer or `false` to open/close it immediately.
    /// - parameter completion: The block to be called when the opening/closing finishes.
    open func toggleDrawer(_ side: KZDrawerSide, animated: Bool, completion: ((Bool) -> Void)?) {
        switch drawerState {
        case .closed:
            openDrawer(side, animated: animated, completion: completion)
        case .open where side == currentDrawerSide:
            closeDrawer(side, animated: animated, completion: completion)
        default:
            completion?(false)
        }
    }

    // MARK: - Handling Gesture Recognizers

    final func didRecognizeScreenEdgePanGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard drawerState == .closed || drawerState == .dragging else { return }
        guard lastSettledDrawerState == .closed else { return }

        let side: KZDrawerSide = gestureRecognizer == leftDrawerOpenWithScreenEdgePanGestureRecognizer ? .left : .right
        let state: UIGestureRecognizerState = gestureRecognizer.state
        let velocity: CGPoint = gestureRecognizer.velocity(in: containerView)
        let translation: CGPoint = gestureRecognizer.translation(in: containerView)

        guard let sideViewController = sideViewControllerFor(side) else { return }

        switch (state) {
        case .began:
            drawerState = .dragging
            currentDrawerSide = side

            willOpenViewController(sideViewController, forSide: side, animated: true)

            sideViewContainerFor(side).isHidden = false
            containerView.isUserInteractionEnabled = false

            if side == .left {
                containerView.leftView = sideViewController.view
            } else {
                containerView.rightView = sideViewController.view
            }

        case .changed where drawerState == .dragging:
            if side == .left {
                let offset: CGFloat = max(translation.x, 0) / containerView.leftViewWidth
                containerView.leftViewSlideOffset = offset
            } else {
                let offset: CGFloat = -min(translation.x, 0) / containerView.rightViewWidth
                containerView.rightViewSlideOffset = offset
            }

            sideViewContainerFor(side).backgroundColor = dimmingColorFor(side)

        case .ended where drawerState == .dragging, .cancelled where drawerState == .dragging:
            let animationVelocity: CGFloat = max(abs(velocity.x), minimumAnimationVelocity)

            if (velocity.x > 100 && side == .left) || (velocity.x < -100 && side == .right) {
                openDrawer(side, velocity: animationVelocity, animated: true, completion: nil)
            } else if (velocity.x > 100 && side == .right) || (velocity.x < -100 && side == .left) {
                closeDrawer(side, velocity: animationVelocity, animated: true, completion: nil)
            } else if slideOffsetFor(side) > 0.5 {
                openDrawer(side, velocity: animationVelocity, animated: true, completion: nil)
            } else {
                closeDrawer(side, velocity: animationVelocity, animated: true, completion: nil)
            }

        default:
            break
        }
    }

    final func didRecognizeTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard drawerState == .open else { return }

        if gestureRecognizer == leftDrawerCloseOnTapGestureRecognizer {
            closeDrawer(.left, animated: true, completion: nil)
        } else {
            closeDrawer(.right, animated: true, completion: nil)
        }
    }

    final func didRecognizePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard drawerState == .open || drawerState == .dragging else { return }
        guard lastSettledDrawerState == .open else { return }

        let side: KZDrawerSide = gestureRecognizer == leftDrawerCloseWithPanGestureRecognizer ? .left : .right
        let state: UIGestureRecognizerState = gestureRecognizer.state
        let location: CGPoint = gestureRecognizer.location(in: containerView)
        let velocity: CGPoint = gestureRecognizer.velocity(in: containerView)

        guard let sideViewController = sideViewControllerFor(side) else { return }

        if side == .left && location.x > containerView.leftViewWidth {
            gestureRecognizer.setTranslation(CGPoint.zero, in: containerView)
        } else if side == .right && location.x < containerView.frame.width - containerView.rightViewWidth {
            gestureRecognizer.setTranslation(CGPoint.zero, in: containerView)
        } else if drawerState != .dragging && (side == .left && velocity.x < 0 || side == .right && velocity.x > 0) {
            gestureRecognizer.setTranslation(CGPoint.zero, in: containerView)

            drawerState = .dragging

            willCloseViewController(sideViewController, forSide: side, animated: true)

            containerView.isUserInteractionEnabled = false
        }

        if drawerState != .dragging {
            return
        }

        let translation: CGPoint = gestureRecognizer.translation(in: containerView)

        switch (state) {
        case .changed:
            if side == .left {
                let offset: CGFloat = 1 - -min(translation.x, 0) / containerView.leftViewWidth
                containerView.leftViewSlideOffset = offset
            } else {
                let offset: CGFloat = 1 - max(translation.x, 0) / containerView.rightViewWidth
                containerView.rightViewSlideOffset = offset
            }

            sideViewContainerFor(side).backgroundColor = dimmingColorFor(side)

        case .ended, .cancelled:
            let animationVelocity: CGFloat = max(abs(velocity.x), minimumAnimationVelocity)

            if (velocity.x > 100 && side == .left) || (velocity.x < -100 && side == .right) {
                openDrawer(side, velocity: animationVelocity, animated: true, completion: nil)
            } else if (velocity.x > 100 && side == .right) || (velocity.x < -100 && side == .left) {
                closeDrawer(side, velocity: animationVelocity, animated: true, completion: nil)
            } else if slideOffsetFor(side) > 0.5 {
                openDrawer(side, velocity: animationVelocity, animated: true, completion: nil)
            } else {
                closeDrawer(side, velocity: animationVelocity, animated: true, completion: nil)
            }

        default:
            break
        }
    }

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard drawerState != .settlingOpen else { return false }
        guard drawerState != .settlingClosed else { return false }

        switch gestureRecognizer {
        case leftDrawerOpenWithScreenEdgePanGestureRecognizer:
            return leftViewController != nil && lastSettledDrawerState == .closed
        case rightDrawerOpenWithScreenEdgePanGestureRecognizer:
            return rightViewController != nil && lastSettledDrawerState == .closed
        case leftDrawerCloseOnTapGestureRecognizer, rightDrawerCloseOnTapGestureRecognizer:
            return touch.view == gestureRecognizer.view && drawerState == .open
        case leftDrawerCloseWithPanGestureRecognizer, rightDrawerCloseWithPanGestureRecognizer:
            return lastSettledDrawerState == .open
        default:
            return false
        }
    }

    // MARK: - Managing the Status Bar

    open override var childViewControllerForStatusBarHidden: UIViewController? {
        get {
            if let currentDrawerSide = currentDrawerSide , drawerState == .open || drawerState == .settlingOpen {
                return sideViewControllerFor(currentDrawerSide)
            } else {
                return centerViewController
            }
     
        }
    }

    // MARK: - Managing Child View Controllers

    open override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        get {
            return false
        }
    }

    // MARK: - Responding to View Events

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        centerViewController?.beginAppearanceTransition(true, animated: animated)

        if let currentDrawerSide = currentDrawerSide , drawerState != .settlingClosed {
            sideViewControllerFor(currentDrawerSide)?.beginAppearanceTransition(true, animated: animated)
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        centerViewController?.endAppearanceTransition()

        if let currentDrawerSide = currentDrawerSide , drawerState != .settlingClosed {
            sideViewControllerFor(currentDrawerSide)?.endAppearanceTransition()
        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        centerViewController?.beginAppearanceTransition(false, animated: animated)

        if let currentDrawerSide = currentDrawerSide , drawerState != .settlingClosed {
            sideViewControllerFor(currentDrawerSide)?.beginAppearanceTransition(false, animated: animated)
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        centerViewController?.endAppearanceTransition()

        if let currentDrawerSide = currentDrawerSide , drawerState != .settlingClosed {
            sideViewControllerFor(currentDrawerSide)?.endAppearanceTransition()
        }
    }

    // MARK: - Configuring the View Rotation Settings
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if let orientations = delegate?.sideDrawerControllerSupportedInterfaceOrientations?(self) {
                return orientations
            }
            return super.supportedInterfaceOrientations
        }
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get {
            if let orientations = delegate?.sideDrawerControllerPreferredInterfaceOrientationForPresentation?(self) {
                return orientations
            } else {
                return super.preferredInterfaceOrientationForPresentation
            }

        }
    }

    // MARK: - Helpers

    fileprivate func replaceCenterViewController(_ oldCenterViewController: UIViewController?, withViewController newCenterViewController: UIViewController?) {
        oldCenterViewController?.willMove(toParentViewController: nil)
        if let newCenterViewController = newCenterViewController {
            addChildViewController(newCenterViewController)
        }

        oldCenterViewController?.beginAppearanceTransition(false, animated: false)
        newCenterViewController?.beginAppearanceTransition(true, animated: false)

        containerView.centerView = newCenterViewController?.view

        oldCenterViewController?.endAppearanceTransition()
        newCenterViewController?.endAppearanceTransition()

        oldCenterViewController?.removeFromParentViewController()
        newCenterViewController?.didMove(toParentViewController: self)
    }

    fileprivate func replaceSideViewController(_ oldSideViewController: UIViewController?, withViewController newSideViewController: UIViewController?, side: KZDrawerSide) {
        oldSideViewController?.willMove(toParentViewController: nil)
        if let newSideViewController = newSideViewController {
            addChildViewController(newSideViewController)
        }

        if currentDrawerSide == side && drawerState != .settlingClosed {
            oldSideViewController?.beginAppearanceTransition(false, animated: false)
            newSideViewController?.beginAppearanceTransition(true, animated: false)

            if side == .left {
                containerView.leftView = newSideViewController?.view
            } else {
                containerView.rightView = newSideViewController?.view
            }
        }

        if currentDrawerSide == side && drawerState != .settlingClosed {
            oldSideViewController?.endAppearanceTransition()
            newSideViewController?.endAppearanceTransition()
        }

        oldSideViewController?.removeFromParentViewController()
        newSideViewController?.didMove(toParentViewController: self)
    }

    fileprivate func slideOffsetFor(_ side: KZDrawerSide) -> CGFloat {
        return side == .left ? containerView.leftViewSlideOffset : containerView.rightViewSlideOffset
    }

    fileprivate func sideViewContainerFor(_ side: KZDrawerSide) -> UIView {
        return side == .left ? containerView.leftContainerView : containerView.rightContainerView
    }

    fileprivate func sideViewControllerFor(_ side: KZDrawerSide) -> UIViewController? {
        return side == .left ? leftViewController : rightViewController
    }

    fileprivate func dimmingColorFor(_ side: KZDrawerSide) -> UIColor {
        return dimmingColor.withAlphaComponent(dimmingColor.cgColor.alpha * slideOffsetFor(side))
    }

    fileprivate func willOpenViewController(_ viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {
        viewController.beginAppearanceTransition(true, animated: animated)
        delegate?.sideDrawerController?(self, willOpenViewController: viewController, forSide: side, animated: animated)
    }

    fileprivate func didOpenViewController(_ viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {
        viewController.endAppearanceTransition()
        delegate?.sideDrawerController?(self, didOpenViewController: viewController, forSide: side, animated: animated)
    }

    fileprivate func willCloseViewController(_ viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {
        viewController.beginAppearanceTransition(false, animated: animated)
        delegate?.sideDrawerController?(self, willCloseViewController: viewController, forSide: side, animated: animated)
    }

    fileprivate func didCloseViewController(_ viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {
        viewController.endAppearanceTransition()
        delegate?.sideDrawerController?(self, didCloseViewController: viewController, forSide: side, animated: animated)
    }

}
