//
//  ReusableViewProtocol.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/10.
//

import UIKit

protocol ReusableViewProtocol {
    static var reuseIdentifier: String { get } //저장 프로퍼티이든 연산프로퍼티 이든 상관없다.
}

extension UICollectionViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {       // 연산 프로퍼티만 가능 - extension 이라서
        return String(describing: self)
    }
}
extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
