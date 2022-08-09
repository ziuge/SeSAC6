//
//  ClosureViewController.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
