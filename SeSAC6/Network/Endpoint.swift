//
//  Endpoint.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/08.
//

import Foundation

enum Endpoint {
//    static let blog = "\(URL.baseURL)blog"
//    static let cafe = "\(URL.baseURL)cafe"
    
    case blog
    case cafe
    
    // 저장 프로퍼티를 못 쓰는 이유?
    // 인스턴스 생성 불가
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case .cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
}
