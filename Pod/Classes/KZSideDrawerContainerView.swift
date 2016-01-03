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
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
                newCenterView.translatesAutoresizingMaskIntoConstraints = false
                centerContainerView.addSubview(newCenterView)
                addConstraintsForCenterView(newCenterView)
            }
        }
    }

    var leftView: UIView? {
        get {
            return leftContainerView.subviews.first
        }
        set(newLeftView) {
            if let leftView = leftView {
                removeConstraintsForLeftView(leftView)
                leftView.removeFromSuperview()
            }

            if let newLeftView = newLeftView {
                newLeftView.translatesAutoresizingMaskIntoConstraints = false
                leftContainerView.addSubview(newLeftView)
                addConstraintsForLeftView(newLeftView)
            }
        }
    }

    var rightView: UIView? {
        get {
            return rightContainerView.subviews.first
        }
        set(newRightView) {
            if let rightView = rightView {
                removeConstraintsForRightView(rightView)
                rightView.removeFromSuperview()
            }

            if let newRightView = newRightView {
                newRightView.translatesAutoresizingMaskIntoConstraints = false
                rightContainerView.addSubview(newRightView)
                addConstraintsForRightView(newRightView)
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

    private lazy var immutableConstraintsForCenterContainerView: [NSLayoutConstraint] = [
        NSLayoutConstraint(item: self.centerContainerView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.centerContainerView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.centerContainerView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: self.centerContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0),
    ]

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

    private var widthConstraintForLeftView: NSLayoutConstraint?

    private var widthConstraintForRightView: NSLayoutConstraint?

    // MARK: - Initializing

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(centerContainerView)
        addSubview(leftContainerView)
        addSubview(rightContainerView)

        addConstraintsForCenterContainerView()
        addConstraintsForLeftContainerView()
        addConstraintsForRightContainerView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Updating Constraints

    override func updateConstraints() {
        widthConstraintForLeftContainerView.constant = leftViewClippedWidth
        widthConstraintForRightContainerView.constant = rightViewClippedWidth

        widthConstraintForLeftView?.constant = leftViewWidth
        widthConstraintForRightView?.constant = rightViewWidth

        super.updateConstraints()
    }

    // MARK: - Helpers

    private func immutableConstraintsForCenterView(centerView: UIView) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: centerView, attribute: .Left, relatedBy: .Equal, toItem: centerContainerView, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: centerView, attribute: .Right, relatedBy: .Equal, toItem: centerContainerView, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: centerView, attribute: .Top, relatedBy: .Equal, toItem: centerContainerView, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: centerView, attribute: .Bottom, relatedBy: .Equal, toItem: centerContainerView, attribute: .Bottom, multiplier: 1, constant: 0),
        ]
    }

    private func immutableConstraintsForLeftView(leftView: UIView) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: leftView, attribute: .Left, relatedBy: .Equal, toItem: leftContainerView, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: leftView, attribute: .Top, relatedBy: .Equal, toItem: leftContainerView, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: leftView, attribute: .Bottom, relatedBy: .Equal, toItem: leftContainerView, attribute: .Bottom, multiplier: 1, constant: 0),
        ]
    }

    private func immutableConstraintsForRightView(rightView: UIView) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: rightView, attribute: .Right, relatedBy: .Equal, toItem: rightContainerView, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rightView, attribute: .Top, relatedBy: .Equal, toItem: rightContainerView, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rightView, attribute: .Bottom, relatedBy: .Equal, toItem: rightContainerView, attribute: .Bottom, multiplier: 1, constant: 0),
        ]
    }

    private func widthConstraintForLeftView(leftView: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: leftView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: leftViewWidth)
    }

    private func widthConstraintForRightView(rightView: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: rightView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: rightViewWidth)
    }

    private func addConstraintsForCenterContainerView() {
        addConstraints(immutableConstraintsForCenterContainerView)
    }

    private func addConstraintsForLeftContainerView() {
        addConstraints(immutableConstraintsForLeftContainerView)
        addConstraint(widthConstraintForLeftContainerView)
    }

    private func addConstraintsForRightContainerView() {
        addConstraints(immutableConstraintsForRightContainerView)
        addConstraint(widthConstraintForRightContainerView)
    }

    private func addConstraintsForCenterView(centerView: UIView) {
        centerContainerView.addConstraints(immutableConstraintsForCenterView(centerView))
    }

    private func addConstraintsForLeftView(leftView: UIView) {
        leftContainerView.addConstraints(immutableConstraintsForLeftView(leftView))
        widthConstraintForLeftView = widthConstraintForLeftView(leftView)
        leftView.addConstraint(widthConstraintForLeftView!)
    }

    private func addConstraintsForRightView(rightView: UIView) {
        rightContainerView.addConstraints(immutableConstraintsForRightView(rightView))
        widthConstraintForRightView = widthConstraintForRightView(rightView)
        rightView.addConstraint(widthConstraintForRightView!)
    }

    private func removeConstraintsForLeftView(leftView: UIView) {
        if let widthConstraintForLeftView = widthConstraintForLeftView {
            leftView.removeConstraint(widthConstraintForLeftView)
        }
    }

    private func removeConstraintsForRightView(rightView: UIView) {
        if let widthConstraintForRightView = widthConstraintForRightView {
            rightView.removeConstraint(widthConstraintForRightView)
        }
    }

}