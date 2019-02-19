//
//  LoadersTests.swift
//  LoadersTests
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import XCTest
@testable import Loaders

//FAKE TESTS !

enum RegistrationCells: Nib {

    static var testCell: Reusable<TestCell> { return load() }
}

enum WalksStoryboards { // in module(?) all typed controllers

    enum Explore: Storyboard, HasInitialController {
        typealias InitialControllerType = ExploreViewController // optional - if not declared it will be just UIViewController

        static var homeViewController: LiveWalkViewController { return load() } // may be plain UIViewController
        static func ticketsViewController() -> CoachHomeViewController { return load() } // may be plain UIViewController
    }

    enum BookWalk: Storyboard, HasInitialController { typealias InitialControllerType = BookWalkViewController }
    enum MyWalksCoach: Storyboard, HasInitialController { typealias InitialControllerType = MyWalksCoachViewController }

    enum InternalStoryboard:  Storyboard, HasInitialController { //?
        case detailsViewController, exploreViewController
    }
}

public enum AppStoryboards { // eg. UICommon module - we only needs UIViewControllers in ReMVVM not typed controlers

    public enum WalkUI { // module

        public enum Explore: String, Storyboard {
            case detailsViewController, exploreViewController, initialViewController
            //identifiers in storyBoard - 'DetailsViewController' or 'detailsViewController',
            //'ExploreViewController' or 'exploreViewController'
            // initialViewController is storyboard's initial view controller or with identifier 'initialViewController'

        }
    }
}

// Unit Tests for checking every controller
extension AppStoryboards.WalkUI.Explore: CaseIterable { } // in Unit Tests

public func testLoad() {

    RegistrationCells.testCell.register(on: UITableView())
    _ = AppStoryboards.WalkUI.Explore.allCases.map { $0.load() } // check if all iterable controllers are loading properly

    let _: ConfirmDetailsViewController = AppStoryboards.WalkUI.Explore.detailsViewController.load() // type checking ?

    _ = WalksStoryboards.Explore.initialViewController()
    _ = WalksStoryboards.Explore.homeViewController
    _ = WalksStoryboards.Explore.ticketsViewController()
}

class TestCell: UITableViewCell { }
class ExploreViewController: UIViewController { }
class LiveWalkViewController: UIViewController { }
class CoachHomeViewController: UIViewController { }
class BookWalkViewController: UIViewController { }
class MyWalksCoachViewController: UIViewController { }
class InternalStoryboard: UIViewController { }
class ConfirmDetailsViewController: UIViewController { }

class LoadersTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
