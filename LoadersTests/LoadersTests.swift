//
//  LoadersTests.swift
//  LoadersTests
//
//  Created by Dariusz Grzeszczak on 19/02/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import XCTest
@testable import Loaders

enum Storyboards {
    enum FirstSingle: Storyboard, HasInitialController { }

    enum SecondSingle: Storyboard, HasInitialController {
        typealias InitialControllerType = SecondSingleViewController
    }

    enum FirstMultiple: Storyboard {
        static var firstMultipleViewController1: FirstMultipleViewController1 { return load() }
        static var firstMultipleViewController2: FirstMultipleViewController2 { return load() }
        static var firstMultipleViewController3: FirstMultipleViewController3 { return load() }
    }

    enum WithFunctionsExample {
        enum FirstMultiple: Storyboard {
            static func firstMultipleViewController1() -> FirstMultipleViewController1 { return load() }
            static func firstMultipleViewController2() -> FirstMultipleViewController2 { return load() }
            static func firstMultipleViewController3() -> FirstMultipleViewController3 { return load() }
        }
    }

    enum SecondMultiple: String, Storyboard {
        case initialViewController
        case secondMultipleViewController1
        case secondMultipleViewController2
        case secondMultipleViewController3
    }

    enum LoadersTestsModule {
        enum InModule: Storyboard, HasInitialController { }
    }
}

extension Storyboards.SecondMultiple: CaseIterable { } //for tests only

enum CollectionViewCells: Nibs {

    static var firstCollectionViewCell: Reusable<FirstCollectionViewCell> { return load() }
    static var secondCollectionViewCell: Reusable<SecondCollectionViewCell> { return load() }
    static var collectionReusableView: Reusable<CollectionReusableView> { return load() }
}

enum TableViewCells: Nibs {

    static var firstTableViewCell: Reusable<FirstTableViewCell> { return load() }
    static var secondTableViewCell: Reusable<SecondTableViewCell> { return load() }
}

class LoadersTests: XCTestCase {

    func testTableView() {

        let tableView = UITableView()

        TableViewCells.firstTableViewCell.register(on: tableView)
        TableViewCells.secondTableViewCell.register(on: tableView)

        let indexPath = IndexPath(row: 0, section: 0)
        _ = TableViewCells.firstTableViewCell.dequeue(on: tableView, for: indexPath)
        _ = TableViewCells.secondTableViewCell.dequeue(on: tableView, for: indexPath)

        //or just
        _ = TableViewCells.firstTableViewCell.instantiate()
        _ = TableViewCells.secondTableViewCell.instantiate()
    }

    func testCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        CollectionViewCells.firstCollectionViewCell.register(on: collectionView)
        CollectionViewCells.secondCollectionViewCell.register(on: collectionView)
        CollectionViewCells.collectionReusableView.register(on: collectionView, forSupplementaryViewOfKind: .header)

        let indexPath = IndexPath(item: 0, section: 0)
        _ = CollectionViewCells.firstCollectionViewCell.dequeue(on: collectionView, for: indexPath)
        _ = CollectionViewCells.secondCollectionViewCell.dequeue(on: collectionView, for: indexPath)
        _ = CollectionViewCells.collectionReusableView.dequeue(on: collectionView, kind: .header, for: indexPath)

        //or just
        _ = CollectionViewCells.firstCollectionViewCell.instantiate()
        _ = CollectionViewCells.secondCollectionViewCell.instantiate()
        _ = CollectionViewCells.collectionReusableView.instantiate()
    }

    func testDesignable() {
        let view = DesignableView(frame: .zero)
        view.title = "new title"
    }

    func testStoryboards() {
        _ = Storyboards.FirstSingle.initialViewController() // UIViewController
        _ = Storyboards.SecondSingle.initialViewController() // SecondSingleViewController

        _ = Storyboards.FirstMultiple.firstMultipleViewController1 // FirstMultipleViewController1
        _ = Storyboards.FirstMultiple.firstMultipleViewController2 // FirstMultipleViewController2
        _ = Storyboards.FirstMultiple.firstMultipleViewController3 // FirstMultipleViewController3

        _ = Storyboards.WithFunctionsExample.FirstMultiple.firstMultipleViewController1() // FirstMultipleViewController1
        _ = Storyboards.WithFunctionsExample.FirstMultiple.firstMultipleViewController2() // FirstMultipleViewController2
        _ = Storyboards.WithFunctionsExample.FirstMultiple.firstMultipleViewController3() // FirstMultipleViewController3

        _ = Storyboards.SecondMultiple.secondMultipleViewController1.load() // UIViewController
        _ = Storyboards.SecondMultiple.secondMultipleViewController2.load() // UIViewController
        _ = Storyboards.SecondMultiple.secondMultipleViewController3.load() // UIViewController

        let _: SecondMultipleViewController1 = Storyboards.SecondMultiple.secondMultipleViewController1.load()
        let _: SecondMultipleViewController2 = Storyboards.SecondMultiple.secondMultipleViewController2.load()
        let _: SecondMultipleViewController3 = Storyboards.SecondMultiple.secondMultipleViewController3.load()

        _ = Storyboards.SecondMultiple.allCases.map { $0.load() } //[UIViewControllers]

        _ = Storyboards.LoadersTestsModule.InModule.initialViewController() // UIViewController
    }
}
