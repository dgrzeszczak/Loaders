//
//  File.swift
//  
//
//  Created by Dariusz Grzeszczak on 07/09/2020.
//

import Foundation
import UIKit

/*public*/ protocol Color: BundleLoader {
    var name: String { get }
}
/*public*/ protocol GroupedColor: Color { }

extension Color where Self: RawRepresentable, Self.RawValue == String {
    /*public*/ var name: String { rawValue }
}

extension GroupedColor where Self: RawRepresentable, Self.RawValue == String {
    /*public*/ var name: String { String(describing: Self.self) + "/" + rawValue }
}

extension Color where Self: RawRepresentable, Self.RawValue == String {

    /*public*/ var uiColor: UIColor? {
        UIColor(named: name, in: Self.bundle, compatibleWith: nil)
    }

    /*public*/ func uiColor(for traitCollection: UITraitCollection) -> UIColor? {
        UIColor(named: name, in: Self.bundle, compatibleWith: traitCollection)
    }

    /*public*/ var cgColor: CGColor? {
        uiColor?.cgColor
    }

    /*public*/ func cgColor(for traitCollection: UITraitCollection) -> CGColor? {
        uiColor(for: traitCollection)?.cgColor
    }
}

