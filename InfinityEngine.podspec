#
# Be sure to run `pod lib lint InfinityEngine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "InfinityEngine"
  s.version          = "3.0.5"
  s.summary          = "Elegant Paged Data Handling for UITableView & UICollectionView in Swift"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC

InfinityEngine provides; Elegant TableView & CollectionView paged data handling,
Progressive Protocol Implemtation, Fully customisable Modifers that alter Table/CollectionView behavior,
Placeholders for pre-data responses &
Automatic paged loading indicator

                       DESC

  s.homepage         = "https://github.com/RyanHWillis/InfinityEngine"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "RyanHWillis" => "ryan_h_willis@hotmail.com" }
  s.source           = { :git => "https://github.com/RyanHWillis/InfinityEngine.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'InfinityEngine/Classes/**/*'

  # s.resource_bundles = {
  #   'InfinityEngine' => ['InfinityEngine/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
