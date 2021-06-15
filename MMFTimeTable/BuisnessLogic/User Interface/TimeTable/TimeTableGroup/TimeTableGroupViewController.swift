//
//  TimeTableGroupViewController.swift
//  MMFTimeTable
//
//  Created by mac on 6.05.21.
//

import SnapKit

final class TimeTableGroupViewController: UIViewController {
    private lazy var background: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor(
            red: 29/256,
            green: 74/256,
            blue: 66/256,
            alpha: 1)
        return item
    }()
    
    private lazy var tableView: UITableView = {
        let item = UITableView(frame: .zero, style: .insetGrouped)
        item.backgroundColor = .clear
        return item
    }()

    private lazy var titleView: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor(
            red: 0/256,
            green: 126/256,
            blue: 110/256,
            alpha: 1)
        return item
    }()

    private lazy var titleLabel: UILabel = {
        let item = UILabel()
        item.textAlignment = .center
        item.textColor = .white
        item.numberOfLines = 2
        item.font = UIFont.boldSystemFont(ofSize: 20)
        return item
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(
            red: 0/256,
            green: 126/256,
            blue: 110/256,
            alpha: 1)

        return collectionView
    }()
    
    private var daysData = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"]
    
    private var viewModel: TimeTableViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            titleLabel.text = viewModel.title
            tableViewDataSource = viewModel.lessons
            currentDay = viewModel.day
        }
    }
    
    private var tableViewDataSource: [TimeTableGroupLessons] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var currentDay: String = "" {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let presenter: TimeTableGroupPresenterProtocol
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(presenter: TimeTableGroupPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        tableView.delegate = self
        tableView.dataSource = self

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(TimeTableCollectionCell.self, forCellWithReuseIdentifier: "timeTableCollectionCell")

        tableView.register(TimeTableCell.self, forCellReuseIdentifier: "timeTableCell")
        
        presenter.attachView(self)
        presenter.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

private extension TimeTableGroupViewController {
    func configureUI() {
        titleView.addSubview(titleLabel)

        background.addSubview(titleView)
        background.addSubview(tableView)
        background.addSubview(collectionView)

        view.addSubview(background)
        
        background.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide)
            maker.bottom.equalToSuperview()
        }

        titleView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalTo(background.snp.top)
            maker.height.equalTo(60)
        }

        collectionView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(60)
        }

        tableView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalTo(collectionView.snp.top)
            maker.top.equalTo(titleView.snp.bottom)
        }

        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(titleView)
            maker.centerY.equalTo(titleView)
        }
    }
}

extension TimeTableGroupViewController: TimeTableGroupViewProtocol {
    func openBroadcasts(_ presenter: BroadcastPresenterProtocol) {
        let vc = BroadcastViewController(presenter: presenter)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateItems(data: TimeTableViewModel) {
viewModel = data
    }
}

extension TimeTableGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.onBroadcasts(indexPath.row)
    }
}

extension TimeTableGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableCell") as? TimeTableCell else {
            return UITableViewCell()
        }
        cell.descriptionText = tableViewDataSource[indexPath.row].subtitle
        cell.lessonText = tableViewDataSource[indexPath.row].title
        return cell
    }
}

extension TimeTableGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeTableCollectionCell", for: indexPath) as? TimeTableCollectionCell else {
            return UICollectionViewCell()
        }
        cell.contentView.isUserInteractionEnabled = false
        cell.title = daysData[indexPath.row]
        cell.index = indexPath.row
        if daysData[indexPath.row] == currentDay {
            cell.isSelected = true
        }
        return cell
    }
}

extension TimeTableGroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/7, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentDay = daysData[indexPath.row]
        presenter.changeContent(with: indexPath.row)
    }
}
