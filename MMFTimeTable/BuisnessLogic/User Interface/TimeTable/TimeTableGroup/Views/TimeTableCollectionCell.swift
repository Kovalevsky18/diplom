//
//  TimeTableCollectionCell.swift
//  MMFTimeTable
//
//  Created by mac on 27.05.21.
//

import UIKit

final class TimeTableCollectionCell: UICollectionViewCell {
    private lazy var button: UIButton = {
        let item = UIButton()
        item.setTitleColor(.white,
                             for: .normal)
        item.setTitleColor(UIColor(
                                red: 0/256,
                                green: 126/256,
                                blue: 110/256,
                                alpha: 1),
                             for: .selected)
        return item
    }()
    
    var title: String = "" {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    
    var index: Int?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                button.isSelected = true
                button.backgroundColor = .white
                button.layer.cornerRadius = self.bounds.height/2
            } else {
                button.isSelected = false
                button.backgroundColor = .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TimeTableCollectionCell {
    
    func addSubviews() {
        contentView.addSubview(button)
    }
    
    func setupConstraints() {
        button.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.right.left.equalToSuperview()
        }
    }
}
