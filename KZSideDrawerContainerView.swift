//
//  KZSideDrawerContainerView.swift
//  KZSideDrawerController
//
//  Created by Satoshi Matsumoto on 1/3/16.
//  Copyright © 2016 Satoshi Matsumoto. All rights reserved.
//

import UIKit

class KZSideDrawerContainerView: UIView {

    // MARK: - Container Views

    lazy var centerContainerView: UIView = {
        let view = UIView(frame: self.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    lazy var leftContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var rightContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var leftWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var rightWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Contained Views

    var centerView: UIView? {
        get {
            return centerContainerView.subviews.first
        }
        set(newCenterView) {
            if let centerView = centerView {
                centerView.removeFromSuperview()
            }

            if let newCenterView = newCenterView {
                newCenterView.translatesAutoresizingMaskIntoConstraints = true
                newCenterView.frame = centerContainerView.bounds
                newCenterView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                centerContainerView.addSubview(newCenterView)
            }
        }
    }

    var leftView: UIView? {
        get {
            return leftWrapperView.subviews.first
        }
        set(newLeftView) {
            if let leftView = leftView {
                leftView.removeFromSuperview()
            }

            if let newLeftView = newLeftView {
                newLeftView.translatesAutoresizingMaskIntoConstraints = true
                newLeftView.frame = leftWrapperView.bounds
                newLeftView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                leftWrapperView.addSubview(newLeftView)
            }
        }
    }

    var rightView: UIView? {
        get {
            return rightWrapperView.subviews.first
        }
        set(newRightView) {
            if let rightView = rightView {
                rightView.removeFromSuperview()
            }

            if let newRightView = newRightView {
                newRightView.translatesAutoresizingMaskIntoConstraints = true
                newRightView.frame = rightWrapperView.bounds
                newRightView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                rightWrapperView.addSubview(newRightView)
            }
        }
    }

    // MARK: - Layout Parameters

    var leftViewSlideOffset: CGFloat = 0 {
        didSet {
            leftViewSlideOffset = max(leftViewSlideOffset, 0)
            leftViewSlideOffset = min(leftViewSlideOffset, 1)
            if leftViewSlideOffset != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    var rightViewSlideOffset: CGFloat = 0 {
        didSet {
            rightViewSlideOffset = max(rightViewSlideOffset, 0)
            rightViewSlideOffset = min(rightViewSlideOffset, 1)
            if rightViewSlideOffset != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    var leftViewWidth: CGFloat = 280 {
        didSet {
            if leftViewWidth != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    var rightViewWidth: CGFloat = 280 {
        didSet {
            if rightViewWidth != oldValue {
                setNeedsUpdateConstraints()
            }
        }
    }

    fileprivate var leftViewClippedWidth: CGFloat {
        return leftViewWidth * (1 - leftViewSlideOffset)
    }

    fileprivate var rightViewClippedWidth: CGFloat {
        return rightViewWidth * (1 - rightViewSlideOffset)
    }

    // MARK: - Auto Layout Constraints

    fileprivate lazy var immutableConstraintsForLeftContainerView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.leftContainerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.leftContainerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.leftContainerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
        ]

    fileprivate lazy var immutableConstraintsForRightContainerView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.rightContainerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.rightContainerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.rightContainerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
        ]

    fileprivate lazy var widthConstraintForLeftContainerView: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.leftContainerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: self.leftViewClippedWidth)
    }()

    fileprivate lazy var widthConstraintForRightContainerView: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.rightContainerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: self.rightViewClippedWidth)
    }()

    fileprivate lazy var immutableConstraintsForLeftWrapperView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.leftWrapperView, attribute: .left, relatedBy: .equal, toItem: self.leftContainerView, attribute: .left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.leftWrapperView, attribute: .top, relatedBy: .equal, toItem: self.leftContainerView, attribute: .top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.leftWrapperView, attribute: .bottom, relatedBy: .equal, toItem: self.leftContainerView, attribute: .bottom, multiplier: 1, constant: 0),
        ]

    fileprivate lazy var immutableConstraintsForRightWrapperView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.rightWrapperView, attribute: .right, relatedBy: .equal, toItem: self.rightContainerView, attribute: .right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.rightWrapperView, attribute: .top, relatedBy: .equal, toItem: self.rightContainerView, attribute: .top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.rightWrapperView, attribute: .bottom, relatedBy: .equal, toItem: self.rightContainerView, attribute: .bottom, multiplier: 1, constant: 0),
        ]

    fileprivate lazy var widthConstraintForLeftWrapperView: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.leftWrapperView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.leftViewWidth)
    }()

    fileprivate lazy var widthConstraintForRightWrapperView: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.rightWrapperView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.rightViewWidth)
    }()

    // MARK: - Initializing

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(centerContainerView)
        addSubview(leftContainerView)
        addSubview(rightContainerView)

        addConstraintsForLeftContainerView()
        addConstraintsForRightContainerView()

        leftContainerView.addSubview(leftWrapperView)
        rightContainerView.addSubview(rightWrapperView)

        addConstraintsForLeftWrapperView()
        addConstraintsForRightWrapperView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Updating Constraints

    override func updateConstraints() {
        widthConstraintForLeftContainerView.constant = leftViewClippedWidth
        widthConstraintForRightContainerView.constant = rightViewClippedWidth

        widthConstraintForLeftWrapperView.constant = leftViewWidth
        widthConstraintForRightWrapperView.constant = rightViewWidth

        super.updateConstraints()
    }

    // MARK: - Helpers

    fileprivate func addConstraintsForLeftContainerView() {
        addConstraints(immutableConstraintsForLeftContainerView)
        addConstraint(widthConstraintForLeftContainerView)
    }

    fileprivate func addConstraintsForRightContainerView() {
        addConstraints(immutableConstraintsForRightContainerView)
        addConstraint(widthConstraintForRightContainerView)
    }

    fileprivate func addConstraintsForLeftWrapperView() {
        leftContainerView.addConstraints(immutableConstraintsForLeftWrapperView)
        leftWrapperView.addConstraint(widthConstraintForLeftWrapperView)
    }

    fileprivate func addConstraintsForRightWrapperView() {
        rightContainerView.addConstraints(immutableConstraintsForRightWrapperView)
        rightWrapperView.addConstraint(widthConstraintForRightWrapperView)
    }

}
