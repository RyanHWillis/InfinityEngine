<p align="center">
    <img src="https://cdn.rawgit.com/RyanHWillis/InfinityEngine/master/Example/infinityenginelogo.jpg"  width="600" height="150" alt="Infinity Engine Logo">
</p>

<p align="center">
    <a href="https://github.com/RyanHWillis/InfinityEngine">Git Repo</a>
  • <a href="https://cocoapods.org/pods/InfinityEngine">Cocoapod</a>
  • <a href="https://opensource.org/licenses/MIT">License</a>
</p>


<p align="center">
    <img src="https://img.shields.io/badge/platform-ios-lightgrey.svg"
         alt="Platform">
    <img src="https://img.shields.io/cocoapods/v/InfinityEngine.svg?style=flat"
         alt="Version">
    <img src="https://img.shields.io/cocoapods/l/InfinityEngine.svg?style=flat"
         alt="License">
    <img src="https://img.shields.io/badge/language-swift-orange.svg"
         alt="Language: Swift">
    <img src="https://img.shields.io/cocoapods/dt/InfinityEngine.svg"
         alt="Downloads: Swift">
    <img src="https://img.shields.io/github/commits-since/RyanHWillis/InfinityEngine/1.3.2.svg"
         alt="CommitsSince: Swift">
</p>

<p align="center">
    <img src="https://img.shields.io/github/stars/badges/shields.svg?style=social&label=Star"
         alt="Star: Swift">
    <img src="https://img.shields.io/github/forks/badges/shields.svg?style=social&label=Fork"
         alt="Fork: Swift">
    <img src="https://img.shields.io/github/stars/badges/shields.svg?style=social&label=Watch"
         alt="Star: Swift">  
    <img src="https://img.shields.io/github/stars/badges/shields.svg?style=social&label=Follow"
         alt="Star: Swift">
</p>

Infinity Engine is an Elegant TableView & CollectionView paged data handling solution, for use with local/external data - to deliever an infinite scrolling experience.

### UITableView & UICollectionView
<p align="center">
    <img src="https://cdn.rawgit.com/RyanHWillis/InfinityEngine/master/Example/collectionview.gif"
         alt="TableView">
    <img src="https://cdn.rawgit.com/RyanHWillis/InfinityEngine/master/Example/tableview.gif"
         alt="CollectionView">
</p>

## Features
+ Elegant TableView & CollectionView paged 'section' data handling
+ Progressive Protocol Implemtation
+ Fully customisable Modifers that alter Table/CollectionView behavior
+ Overrides to implement Placeholders for pre-data responses
+ Automatic loading indicator at bottom whilst waiting for next data response.

## InfinityTableView

Implement 'InfinityTableProtocol' from your UIViewController / UIView

```swift
InfinityTableProtocol
```

After extending 'InfinityTableProtocol', you will need to implement the following callbacks.

```swift
func tableView(_ tableView: UITableView, withDataForPage page: Int, forSession session: String, completion: @escaping (ResponsePayload) -> ()) {
    completion(ResponsePayload(count: [8, 3, 12], lastPage: false, session: session))
}

func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
    return self.tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
}

func tableView(_ tableView: UITableView, withLoadingCellItemForIndexPath indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as! LoadingTableViewCell
    return cell
}

func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath, forLoadingCell loadingCell: Bool) -> CGFloat {
    if loadingCell {
        return 30.0
    }
    return 98.0
}
```

Some quick setup

#### Note: Cell names given must define the actual class name, the same class name will be used to dequeueReusableCell (See Above)

```swift
let cells = InfinityCells(cellNames: ["TestTableViewCell", "SectionCell"], loadingCellName: "LoadingTableViewCell", bundle: nil)
let tableView = InfinityTableView(withTableView: self.tableView, withCells: cells, withDataSource: self)
self.startInfinityTableView(infinityTableView: tableView)
```

(Optional) You can extend InfinityTableView functionlality e.g. add further tableView delegates "viewForHeader", by  subclassing TableViewEngine and extending / overriding functionality.

```swift
func createTableViewEngine(_ infinityTableView: InfinityTableView) -> TableViewEngine
```




## Requirements
+ iOS 8.0 +
+ Xcode 7.3 +

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

InfinityEngine is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "InfinityEngine"
```

## Author

RyanHWillis, ryan_h_willis@hotmail.com

## License

InfinityEngine is available under the MIT license. See the LICENSE file for more info.
