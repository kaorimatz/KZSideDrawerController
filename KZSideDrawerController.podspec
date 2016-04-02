#
# Be sure to run `pod lib lint KZSideDrawerController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "KZSideDrawerController"
  s.version          = "0.0.5"
  s.summary          = "A side drawer controller for iOS written in Swift"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
KZSideDrawerController is a side drawer controller for iOS written in Swift.
                       DESC

  s.homepage         = "https://github.com/kaorimatz/KZSideDrawerController"
  s.screenshots      = [
    "http://kaorimatz.github.io/KZSideDrawerController/screenshots/1.png",
    "http://kaorimatz.github.io/KZSideDrawerController/screenshots/2.png",
  ]
  s.license          = "MIT"
  s.author           = { "Satoshi Matsumoto" => "kaorimatz@gmail.com" }
  s.source           = { :git => "https://github.com/kaorimatz/KZSideDrawerController.git", :tag => s.version.to_s }
  # s.social_media_url = "https://twitter.com/<TWITTER_USERNAME>"

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source_files = "Pod/Classes/**/*"
  s.resource_bundles = {
    "KZSideDrawerController" => ["Pod/Assets/*.png"]
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
