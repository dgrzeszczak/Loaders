//
//  ViewModelDriven.swift
//  Loaders
//
//  Created by Dariusz Grzeszczak on 21/03/2019.
//  Copyright © 2019 Dariusz Grzeszczak. All rights reserved.
//

public enum ViewModelDrivenConfig {
    public enum Controller {
        public static var loadViewAndObserve = true
    }
}

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
        set { _viewModel = newValue }
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
        cell.observeViewModel()
        return cell
    }
}

extension Reusable where View: UICollectionViewCell, View: ViewModelDriven {

    public func dequeue(on collectionView: UICollectionView, for indexPath: IndexPath, with viewModel: View.ViewModelType) -> View {

        let cell = dequeue(on: collectionView, for: indexPath)
        cell.viewModel = viewModel
        cell.observeViewModel()
        return cell
    }
}

extension Reusable where View: UICollectionReusableView, View: ViewModelDriven {

    public func dequeue(on collectionView: UICollectionView, kind: ReusableCollectionViewKind, for indexPath: IndexPath, with viewModel: View.ViewModelType) -> View {

        let view = dequeue(on: collectionView, kind: kind, for: indexPath)
        view.viewModel = viewModel
        view.observeViewModel()
        return view
    }
}
