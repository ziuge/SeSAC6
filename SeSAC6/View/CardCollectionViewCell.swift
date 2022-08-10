//
//  CardCollectionViewCell.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    // 변경되지 않는 UI를 여기에 작성하면 효율적임
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("CardCollectionViewCell", #function)
        setupUI()
    }
    
    // 재사용을 위한 준비
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cardView.contentLabel.text = "A"
    }
    
    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.likeBtn.tintColor = .systemPink
        
    }

}
