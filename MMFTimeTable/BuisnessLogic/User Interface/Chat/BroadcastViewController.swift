//
//  BroadcastViewController.swift
//  MMFTimeTable
//
//  Created by mac on 30.05.21.
//

import SnapKit
import WebKit

final class BroadcastViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let item = WKWebView()
        item.allowsBackForwardNavigationGestures = true
        return item
    }()
    
    let presenter: BroadcastPresenterProtocol
    
    init(presenter: BroadcastPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()      
        presenter.attachView(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor(
            red: 29/256,
            green: 74/256,
            blue: 66/256,
            alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
}

private extension BroadcastViewController {
    func configureUI() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide)
            maker.bottom.equalToSuperview()   
        }
    }
}

extension BroadcastViewController: BroadcastViewProtocol {
    func loadTitle(title: String) {
        self.title = title
    }
    
    func loadUrl(url: String) {
        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }
}

