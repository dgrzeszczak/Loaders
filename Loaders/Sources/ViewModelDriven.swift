//
//  ViewModelDriven.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 21/03/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewModelDriven: class {
    associatedtype ViewModelType

    var viewModel: ViewModelType { get set }
    func bind(viewModel: ViewModelType)
}

private struct AssociatedKeys {
    static var viewModelKey = "com.db.viewModel"
    static var observerKey = "com.db.observer"
}

private extension UIResponder {
     @objc dynamic var _viewModel: Any? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModelKey) }
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModelKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    var _observer: Any? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.observerKey) }
        set { objc_setAssociatedObject(self, &AssociatedKeys.observerKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

extension ViewModelDriven where Self: UIResponder {

    public var viewModel: ViewModelType {
        get { return _viewModel as! ViewModelType}
        set { _viewModel = newValue; observeViewModel() }
    }

    public func observeViewModel(force: Bool = false) {

        guard _observer == nil || force else { return }
        _observer = observe(\Self._viewModel, options: [.initial, .new]) { [unowned self] field, observable in
            if let viewModel = observable.newValue as? ViewModelType {
                self.bind(viewModel: viewModel)
            }
        }
    }

    public func unobserveViewModel() {
        _observer = nil
    }

    public func bind(viewModel: ViewModelType) { }
}

extension ViewModelDriven where Self: UIView {

    public init(frame: CGRect, viewModel: ViewModelType) {
        self.init(frame: frame)
        self.viewModel = viewModel
    }

    public init(viewModel: ViewModelType) {
        self.init(frame: .zero)
        self.viewModel = viewModel
    }
}

extension Reusable where View: UITableViewCell, View: ViewModelDriven {

    public func dequeue(on tableView: UITableView, for indexPath: IndexPath, with viewModel: View.ViewModelType) -> View {

        let cell = dequeue(on: tableView, for: indexPath)
        cell.viewModel = viewModel
        return cell
    }
}

extension Reusable where View: UICollectionViewCell, View: ViewModelDriven {

    public func dequeue(on collectionView: UICollectionView, for indexPath: IndexPath, with viewModel: View.ViewModelType) -> View {

        let cell = dequeue(on: collectionView, for: indexPath)
        cell.viewModel = viewModel
        return cell
    }
}

extension Reusable where View: UICollectionReusableView, View: ViewModelDriven {

    public func dequeue(on collectionView: UICollectionView, kind: ReusableCollectionViewKind, for indexPath: IndexPath, with viewModel: View.ViewModelType) -> View {

        let view = dequeue(on: collectionView, kind: kind, for: indexPath)
        view.viewModel = viewModel
        return view
    }
}

extension Loader where Controller: ViewModelDriven {

    public init(identifier: String?,
                storyboardName: String,
                bundle: Bundle,
                with viewModel: Controller.ViewModelType,
                loadViewIfNeeded: Bool = true) {

        self.init {
            let controller: Controller = StoryboardFactory.create(identifier: identifier,
                                                                  storyboardName: storyboardName,
                                                                  bundle: bundle)
            if loadViewIfNeeded {
                controller.loadViewIfNeeded()
            }
            controller.viewModel = viewModel
            return controller
        }
    }

    public init(loader: Loader<Controller>,
                with viewModel: Controller.ViewModelType,
                loadViewIfNeeded: Bool = true) {

        factory = { loader.load(with: viewModel, loadViewIfNeeded: loadViewIfNeeded) }
    }

    public func load(with viewModel: Controller.ViewModelType,
                     loadViewIfNeeded: Bool = true) {

        let controller = load()
        if loadViewIfNeeded {
            controller.loadViewIfNeeded()
        }
        controller.viewModel = viewModel
        return controller
    }
}
