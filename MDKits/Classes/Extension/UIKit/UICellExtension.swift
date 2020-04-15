//
//  UICellExtension.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import UIKit

public protocol Identifiable {
    static var reuseIdentifier: String { get }
}

public extension Identifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// UITableView
extension UITableViewCell: Identifiable {}

extension UITableViewHeaderFooterView: Identifiable {}

public extension MDKit where Base: UITableView{
    func register(_ cellClass: UITableViewCell.Type) {
        base.register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func register(_ headerFooterClass: UITableViewHeaderFooterView.Type) {
        base.register(headerFooterClass.self, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseIdentifier)
    }

    func registerNib(_ cellClass: UITableViewCell.Type) {
        base.register(UINib(nibName: String(describing: cellClass), bundle: nil), forCellReuseIdentifier: cellClass.reuseIdentifier)
    }

    func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath? = nil) -> T where T: UITableViewCell {
        if let indexPath = indexPath, let cell = base.dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T {
            // Storyboard
            return cell
        } else if let cell = base.dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier) as? T {
            // Pure Code
            return cell
        }
        return cellClass.init(style: .default, reuseIdentifier: cellClass.reuseIdentifier)
    }

    func dequeue<T>(_ headerFooterClass: T.Type) -> T where T: UITableViewHeaderFooterView {
        return base.dequeueReusableHeaderFooterView(withIdentifier: headerFooterClass.reuseIdentifier) as! T
    }
}



// UICollectionCell
extension UICollectionReusableView: Identifiable {}

public extension MDKit where Base: UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) {
        base.register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    func register(_ cellClass: UICollectionReusableView.Type, ofKind kind: String) {
        base.register(cellClass.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: cellClass.reuseIdentifier)
    }

    func registerNib(_ cellClass: UICollectionViewCell.Type) {
        base.register(UINib(nibName: String(describing: cellClass), bundle: nil), forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        return base.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }

    func dequeue<T>(_ reusableSupplementaryViewClass: T.Type, for indexPath: IndexPath, ofKind kind: String) -> T where T: UICollectionReusableView {
        return base.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reusableSupplementaryViewClass.reuseIdentifier, for: indexPath) as! T
    }
}

