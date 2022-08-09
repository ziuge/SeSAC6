//
//  KakaoAPIManager.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> () ) {
        print(#function)
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        
        // Alamofire -> URLSesstion Framework -> 비동기로 Request
//        DispatchQueue.global().async // 이미 내부적으로 되어 있기 때문에 안 써도 됨!
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print( "JSON: \(json)")
                
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
