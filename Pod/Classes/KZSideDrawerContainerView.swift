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
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
                newCenterView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
                newLeftView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
                newRightView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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

    private var leftViewClippedWidth: CGFloat {
        return leftViewWidth * (1 - leftViewSlideOffset)
    }

    private var rightViewClippedWidth: CGFloat {
        return rightViewWidth * (1 - rightViewSlideOffset)
    }

    // MARK: - Auto Layout Constraints

    private lazy var immutableConstraintsForLeftContainerView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.leftContainerView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.leftContainerView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.leftContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0),
    ]

    private lazy var immutableConstraintsForRightContainerView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.rightContainerView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.rightContainerView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.rightContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0),
    ]

    private lazy var widthConstraintForLeftContainerView: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.leftContainerView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: self.leftViewClippedWidth)
    }()

    private lazy var widthConstraintForRightContainerView: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.rightContainerView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: self.rightViewClippedWidth)
    }()

    private lazy var immutableConstraintsForLeftWrapperView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.leftWrapperView, attribute: .Left, relatedBy: .Equal, toItem: self.leftContainerView, attribute: .Left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.leftWrapperView, attribute: .Top, relatedBy: .Equal, toItem: self.leftContainerView, attribute: .Top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.leftWrapperView, attribute: .Bottom, relatedBy: .Equal, toItem: self.leftContainerView, attribute: .Bottom, multiplier: 1, constant: 0),
    ]

    private lazy var immutableConstraintsForRightWrapperView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.rightWrapperView, attribute: .Right, relatedBy: .Equal, toItem: self.rightContainerView, attribute: .Right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.rightWrapperView, attribute: .Top, relatedBy: .Equal, toItem: self.rightContainerView, attribute: .Top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.rightWrapperView, attribute: .Bottom, relatedBy: .Equal, toItem: self.rightContainerView, attribute: .Bottom, multiplier: 1, constant: 0),
    ]

    private lazy var widthConstraintForLeftWrapperView: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.leftWrapperView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.leftViewWidth)
    }()

    private lazy var widthConstraintForRightWrapperView: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.rightWrapperView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.rightViewWidth)
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

    private func addConstraintsForLeftContainerView() {
        addConstraints(immutableConstraintsForLeftContainerView)
        addConstraint(widthConstraintForLeftContainerView)
    }

    private func addConstraintsForRightContainerView() {
        addConstraints(immutableConstraintsForRightContainerView)
        addConstraint(widthConstraintForRightContainerView)
    }

    private func addConstraintsForLeftWrapperView() {
        leftContainerView.addConstraints(immutableConstraintsForLeftWrapperView)
        leftWrapperView.addConstraint(widthConstraintForLeftWrapperView)
    }

    private func addConstraintsForRightWrapperView() {
        rightContainerView.addConstraints(immutableConstraintsForRightWrapperView)
        rightWrapperView.addConstraint(widthConstraintForRightWrapperView)
    }

}