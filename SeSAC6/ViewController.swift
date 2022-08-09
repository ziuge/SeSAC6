//
//  ViewController.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/08.
//

import UIKit

//import Alamofire
import SwiftyJSON

/*
 MARK: html <b> 없애기
 1. html tag <> </> 기능 활용
 2. 문자열 대체 메서드
 response에서 처리하는 것과 보여지는 셀 등에서 처리하는 것의 차이는? -> 나중에도 사용하기 편함
 */

/*
 MARK: TableView automaticDimension
 - 컨텐츠 양에 따라서 셀 높이가 자유롭게
 - 조건: 레이블 numberOfLines 0 으로 설정
 - 조건: tableView Height automaticDimension으로 설정해야 함
 - 조건: 레이아웃
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false // false 2, true 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBlog()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension // 모든 섹션의 셀에 대해서 유동적으로 잡겠다는 뜻
        
    }

    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
            for item in json["documents"].arrayValue {
                self.blogList.append(item["contents"].stringValue)
            }
            self.searchCafe()
        }
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            for item in json["documents"].arrayValue {
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                
                self.cafeList.append(value)
            }
            print("blog", self.blogList)
            print("cafe", self.cafeList)
            
            self.tableView.reloadData()
        }
    }
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        isExpanded = !isExpanded
        tableView.reloadData()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kakaoCell", for: indexPath) as? kakaoCell else { return UITableViewCell() }
        
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class kakaoCell: UITableViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
}
