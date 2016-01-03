# KZSideDrawerController

[![CI Status](http://img.shields.io/travis/kaorimatz/KZSideDrawerController.svg?style=flat-square)](https://travis-ci.org/kaorimatz/KZSideDrawerController)
[![Version](https://img.shields.io/cocoapods/v/KZSideDrawerController.svg?style=flat-square)](http://cocoapods.org/pods/KZSideDrawerController)
[![License](https://img.shields.io/cocoapods/l/KZSideDrawerController.svg?style=flat-square)](http://cocoapods.org/pods/KZSideDrawerController)
[![Platform](https://img.shields.io/cocoapods/p/KZSideDrawerController.svg?style=flat-square)](http://cocoapods.org/pods/KZSideDrawerController)

KZSideDrawerController is a side drawer controller for iOS written in Swift.

<p align="center">
  <img src="http://kaorimatz.github.io/KZSideDrawerController/screenshots/1.png" width="240" height="426"/>
  <img src="http://kaorimatz.github.io/KZSideDrawerController/screenshots/2.png" width="240" height="426"/>
</p>

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Creating a Side Drawer Controller

```swift
let sideDrawerController = KZSideDrawerController()
sideDrawerController.centerViewController = UIViewController()
sideDrawerController.leftViewController = UIViewController()
sideDrawerController.rightViewController = UIViewController()
```

### Opening and Closing a Drawer

```swift
sideDrawerController.openDrawer(side: .Left, animated: true, completion: nil)
sideDrawerController.closeDrawer(side: .Right, animated: true, completion: nil)
```

### Responding to Side Drawer Controller Events

```swift
extension ViewController: KZSideDrawerControllerDelegate {
    func sideDrawerController(sideDrawerController: KZSideDrawerController, willOpenViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {}
    func sideDrawerController(sideDrawerController: KZSideDrawerController, didOpenViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {}
    func sideDrawerController(sideDrawerController: KZSideDrawerController, willCloseViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {}
    func sideDrawerController(sideDrawerController: KZSideDrawerController, didCloseViewController viewController: UIViewController, forSide side: KZDrawerSide, animated: Bool) {}
}
```

## Requirements

- iOS 7.0

## Installation

KZSideDrawerController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KZSideDrawerController"
```

## Author

Satoshi Matsumoto, kaorimatz@gmail.com

## License

KZSideDrawerController is available under the MIT license. See the LICENSE file for more info.
