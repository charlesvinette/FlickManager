# FlickManager

[![CI Status](http://img.shields.io/travis/Charles Vinette/FlickManager.svg?style=flat)](https://travis-ci.org/Charles Vinette/FlickManager)
[![Version](https://img.shields.io/cocoapods/v/FlickManager.svg?style=flat)](http://cocoapods.org/pods/FlickManager)
[![License](https://img.shields.io/cocoapods/l/FlickManager.svg?style=flat)](http://cocoapods.org/pods/FlickManager)
[![Platform](https://img.shields.io/cocoapods/p/FlickManager.svg?style=flat)](http://cocoapods.org/pods/FlickManager)

## Usage

```swift
//Create the view you want to use the flick manager on
  let vc = UIViewController()
//Create the FlickManager with the previously created VC  
  let vcWithFlickManager = FlickManager(vc)
//You can then configure the Right and Left Button, and add their targets (.TouchUpInside is Mandatory), and add their //constraints
  vcWithFlickManager.rightButton.setImage(bla bla bla)
  vcWithFlickManager.rightButton.addTarget(bla bla bla, .TouchUpInside)
  vcWithFlickManager.rightButtonSize = 100
//Then, Display the vcWithFlickManager
self.presentViewController(vcWithFlickManager)
```

![](http://imgur.com/bVGTpda.gif)

## Requirements
iOS 8 and Higher

## Installation

FlickManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FlickManager"
```

## Author

Charles Vinette, vinettecharles@gmail.com

## License

FlickManager is available under the MIT license. See the LICENSE file for more info.
