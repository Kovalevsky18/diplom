//
//  TimeTableCell.swift
//  MMFTimeTable
//
//  Created by mac on 25.05.21.
//

import UIKit

class TimeTableCell: UITableViewCell {

    private lazy var lessonStepperItem: UIView = {
        let item = UIView()
        item.backgroundColor = .red
        return item
    }()

    private lazy var lessonLabel: UILabel = {
        let item = UILabel()
        item.text = "Мат. Анализ"
        item.font = UIFont.boldSystemFont(ofSize: 16)
        return item
    }()

    private lazy var lessonStackView: UIStackView = {
        let item = UIStackView()
        item.backgroundColor = .clear
        item.spacing = 15
        item.axis = .horizontal
        return item
    }()

    private lazy var descriptionStepperItem: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor(
            red: 0/256,
            green: 126/256,
            blue: 110/256,
            alpha: 1)
        return item
    }()

    private lazy var descriptionLabel: UILabel = {
        let item = UILabel()
        item.textColor = .systemGray
        item.font = UIFont.systemFont(ofSize: 14)
        return item
    }()

    private lazy var descriptionStackView: UIStackView = {
        let item = UIStackView()
        item.backgroundColor = .clear
        item.spacing = 15
        item.axis = .horizontal
        return item
    }()

    var lessonText: String = "" {
        didSet {
            lessonLabel.text = lessonText
        }
    }

    var descriptionText: String = "" {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TimeTableCell {
    func configureUI() {
        lessonStepperItem.snp.makeConstraints { (maker) in
            maker.width.equalTo(20)
            maker.height.equalTo(20)
        }

        lessonStepperItem.layer.cornerRadius = 10

        lessonStackView.addArrangedSubview(lessonStepperItem)
        lessonStackView.addArrangedSubview(lessonLabel)

        descriptionStackView.addArrangedSubview(descriptionStepperItem)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStepperItem.snp.makeConstraints { (maker) in
            maker.width.equalTo(16)
            maker.height.equalTo(16)
        }

        descriptionStepperItem.layer.cornerRadius = 8

        addSubview(lessonStackView)
        addSubview(descriptionStackView)

        lessonStackView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left).offset(15)
            maker.right.equalTo(contentView.snp.right).offset(15)
            maker.top.equalTo(contentView.snp.top).offset(5)
        }

        descriptionStackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(lessonStackView.snp.bottom).offset(10)
            maker.left.equalTo(contentView.snp.left).offset(15)
            maker.right.equalTo(contentView.snp.right).offset(15)
        }
    }
}

