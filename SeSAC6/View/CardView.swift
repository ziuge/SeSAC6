//
//  CardView.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/09.
//

import UIKit

/*
 Xml Interface Builder
 1. UIView Custom Class를 이용하는 방법
 2. File's Owner를 설정하는 방법
 */

/*
 View:
 - 인터페이스 빌더 UI 초기화 구문: required init?
    - 프로토콜 내에서 초기화 구문 작성할 수 있음 : required > 초기화 구문이 프로토콜로 명세되어 있음
 - 코드 UI 초기화 구문: override init

 */

protocol A {
    func example()
    init()
}

class CardView: UIView {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .lightGray
        self.addSubview(view)
        
        print(view.translatesAutoresizingMaskIntoConstraints) // true
        // 카드뷰를 인터페이스 빌더 기반으로 만들고, 레이아웃도 설정했는데 false가 아닌 true로 나온다... 왜?
        // nib, addSubview -> 코드베이스로 뷰를 추가해주었기 때문이다.
        // 오토레이아웃 적용이 되는 관점보다 오토리사이징이 내부적으로 constraints 처리가 됨
    }
}
