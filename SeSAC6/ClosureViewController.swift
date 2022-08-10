//
//  ClosureViewController.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!
    
    // Frame Based
    var sampleBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 위치, 크기, 추가
        print(sampleBtn.translatesAutoresizingMaskIntoConstraints) // true
        print(cardView.translatesAutoresizingMaskIntoConstraints) // false
        sampleBtn.frame = CGRect(x: 100, y: 400, width: 100, height: 100)
        sampleBtn.backgroundColor = .red
        view.addSubview(sampleBtn)
        /*
         오토리사이징을 오토레이아웃 제약조건처럼 설정해주는 기능이 내부적으로 구현되어 있음
         이 기능은 코드로 했는지 인터페이스빌더로 했는지에 따라 디폴트값이 달라짐 (코드 기반 > true, 인터페이스빌더 > false)
         - 디폴트가 True. 오토레이아웃을 지정해주면 오토리사이징을 쓰지 않겠다고 해서 false로 변경됨
         autoresizing -> autolayout constraints
         */

        cardView.posterImageView.backgroundColor = .red
        cardView.likeBtn.backgroundColor = .yellow
        cardView.likeBtn.addTarget(self, action: #selector(likeBtnClicked), for: .touchUpInside) // action 기능 만들어주기
    }
    
    @objc func likeBtnClicked() {
        print("버튼 클릭")
    }
    
    
    @IBAction func colorPickerBtnClicked(_ sender: UIButton) {
        showAlert(title: "컬러피커", message: "띄우시겠습니까?", okTitle: "띄우기") {
            let picker = UIColorPickerViewController()
            self.present(picker, animated: true)
        }
    }
    @IBAction func bgColorChanged(_ sender: UIButton) {
        showAlert(title: "배경색 변경", message: "배경색을 바꾸시겠습니까?", okTitle: "바꾸기", okAction: {
            self.view.backgroundColor = .gray
        })
    }
    
}

extension UIViewController {
    func showAlert(title: String, message: String, okTitle: String, okAction: @escaping () -> () ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { action in
            okAction()
            
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
