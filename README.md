
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Simple μFramework for loading Storyboard and Xib files for iOS.

# Loaders

Let's imagine: 

You have Main.storyboard file with initial view controller and two other controllers with identifiers: "PageViewController", "PageDetailsViewController". You have to instantiate them programatically and all you need to do is to declare enum like that:

```swift
enum Main: String, Storyboard {
    case initialViewController, pageViewController, pageDetailsViewController
}
```

... and you can load view controllers:

```swift
let pageViewController = Main.pageViewController.load()  // type will be UIViewController
```
... or with type:
```swift
let pageViewController: PageViewController = Main.pageViewController.load() 
```

... and also you would like to write Unit Test which will check all the controllers are loading properly. So you write: 

```swift
extension Main: CaseIterable { }

class AppTests: XCTestCase {

    func testMainStoryboard() {
        _ = Main.allCases.map { $0.load() } // [UIViewController] 
    }
}
```
Lucky you ;) You can do that with the ***Loaders***. 

## Other possibilities with Storyboard

When you use single storyboard per view controller you can declare it: 

```swift
enum Details: Storyboard, HasInitialController { }
```

Then you can instantiate controller like that: 

```swift
_ = Details.initialViewController() // UIViewController
```

### Strong types view controllers 

When you need typed initial view controller you have to specify typealias like that:

```swift
enum Details: Storyboard, HasInitialController { 
    typealias InitialControllerType = DetailsViewController
}
```

You can also declare strong type view controllers based on identifiers: 

```swift
enum Main: Storyboard, HasInitialController {
    typealias InitialControllerType = MainViewController
    
    static var pageViewController: PageViewController { return load() }
    static var pageDetailsViewController: PageDetailsViewController { return load() }
}
```

then load:

```swift
_ = Main.initialViewController() // MainViewController 
_ = Main.pageViewController // PageViewController
_ = Main.pageDetailsViewController // PageDetailsViewController
```

If you don't like computed property to work as a fabric you can use methods instead: 

```swift
enum Main: Storyboard, HasInitialController {
    typealias InitialControllerType = MainViewController

    static func pageViewController() -> PageViewController { return load() }
    static func pageDetailsViewController() -> PageDetailsViewController { return load() }
}
```
then load: 

```swift
_ = Main.initialViewController() // MainViewController 
_ = Main.pageViewController() // PageViewController
_ = Main.pageDetailsViewController() // PageDetailsViewController
```
 
# Reusable Nibs

*Loaders* also provides a way to register and deque reusable views loaded from xib files. It works for UITableViewCell, UICollectionViewCell, UICollectionReusableView. The rule you has to follow is that the class name, xib file name and identifier has to be the same. 

```swift
 enum FormCells: Nibs {
 
     static var firstTableViewCell: Reusable<FirstTableViewCell> { return load() }
     static var secondTableViewCell: Reusable<SecondTableViewCell> { return load() }
 }
```

then you can register them: 

```swift
FormCells.firstTableViewCell.register(on: tableView)
```

and later dequeue: 

```swift
let cell = FormCells.firstTableViewCell.dequeue(on: tableView, for: indexPath) // FirstTableViewCell
```
Note: It works exaclty the same for UICollectionView. 

# Modules

If you have storyboards or reusables in different module of your app you can simply enclose declaration in enum with the same name as module. You can still enclose your declaration by any enum for grouping purposes but please remember to not conflict it with any module in your app. 

```swift
enum Storyboards { // there is no modulel 'Storyboards' in the app so it will use 'current' module for Main storyboard
    
    enum Main: String, Storyboard {
        case initialViewController, pageViewController, pageDetailsViewController
    }

    enum User { // there is module User in the app it will load storyboards 'Main' and 'Profile' from there
        
        enum Main: String, Storyboard {
            case initialViewController, pageViewController, pageDetailsViewController
        }
        
        enum Profile: Storyboard, HasInitialController { }
    }
}
```

# Custom view from Nib

Creating custom view using xib files instead writing them by hand in code is great idea. It simple but need some boilerplate and usually it is not obvious for beginers how to do it in proper way. Each developer who is using your custom view should have possibility to instantiate that view in storyboards but he also should be able to do it from the code. He also should see the custom view in storyboard properly instead of "white rectangles". *Loaders* provide simple mechanism for loading xib files to custom views corectly.

To make custom designable view you need to create Xib file with the same name as your custom class and set the 'File Owner' with that class to have all IBOutlets initialized properly (remember - do not set 'Custom Class' for the main view - set 'File Owner' only). 

In your custom view you have to add two constructors and inside them you have to add "Xib file" by single line of code ```Nib.add(to: self`)```.  Simple implementation may look like that. 

```swift
@IBDesignable
class DesignableView: UIView {

    @IBOutlet private var label: UILabel!

    @IBInspectable var title: String = "title" {
        didSet {
            label.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        Nib.add(to: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Nib.add(to: self)
    }
}
```
