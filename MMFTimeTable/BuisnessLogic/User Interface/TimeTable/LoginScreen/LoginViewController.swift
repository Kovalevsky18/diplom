//
//  LoginViewController.swift
//  MMFTimeTable
//
//  Created by Родион Ковалевский on 2/24/21.
//

import SnapKit
import UIKit

final class LoginViewController: UIViewController {
    private lazy var background: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor(
            red: 29/256,
            green: 74/256,
            blue: 66/256,
            alpha: 1)
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
    
    private(set) lazy var label: UILabel = {
        let item = UILabel()
        item.textAlignment = .center
        item.textColor = .white
        item.numberOfLines = 2
        item.font = UIFont.boldSystemFont(ofSize: 20)
        item.text = NSLocalizedString("mmf", comment: "title")
        return item
    }()
    
    private(set) lazy var loginField: UITextField = {
        let item = UITextField()
        item.textColor = .white
        item.tag = 0
        item.borderStyle = .none
        item.keyboardType = .emailAddress
        item.attributedPlaceholder = NSAttributedString(string: "login",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor(
                                                                        red: 0/256,
                                                                        green: 126/256,
                                                                        blue: 110/256,
                                                                        alpha: 1)])
        return item
    }()
    
    private(set) lazy var loginSeparatorView: UIView = {
        let item = UIView()
        item.backgroundColor = .white
        return item
    }()
    
    private(set) lazy var passwordField: UITextField = {
        let item = UITextField()
        item.textColor = .white
        item.borderStyle = .none
        item.isSecureTextEntry = true
        item.keyboardType = .emailAddress
        item.tag = 1
        item.attributedPlaceholder = NSAttributedString(string: "password",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor(
                                                                        red: 0/256,
                                                                        green: 126/256,
                                                                        blue: 110/256,
                                                                        alpha: 1)])
        return item
    }()
    
    private(set) lazy var loginButton: UIButton = {
        let item = UIButton()
        item.backgroundColor = .clear
        item.setTitle("Войти", for: .normal)
        item.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return item
    }()
    
    private(set) lazy var passwordSeparatorView: UIView = {
        let item = UIView()
        item.backgroundColor = .white
        return item
    }()
    
    private(set) lazy var alert: UIAlertController = {
        let item = UIAlertController(title: "Что-то пошло не так", message: "не верный логин или пароль", preferredStyle: UIAlertController.Style.alert)
        item.addAction(UIAlertAction(title: "Окей", style: UIAlertAction.Style.default, handler: nil))
        return item
    }()
    
    private(set) lazy var activityIndicator: UIActivityIndicatorView = {
        let item = UIActivityIndicatorView(style: .large)
        item.color = .white
        item.hidesWhenStopped = true
        item.stopAnimating()
        return item
    }()
    
    let presenter: LoginPresenterProtocol
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginField.delegate = self
        passwordField.delegate = self
        
        configureUI()
        
        presenter.attachView(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

private extension LoginViewController {
    func configureUI() {
        titleView.addSubview(label)
        background.addSubview(titleView)
        background.addSubview(loginField)
        background.addSubview(loginSeparatorView)
        background.addSubview(passwordField)
        background.addSubview(passwordSeparatorView)
        background.addSubview(loginButton)
        background.addSubview(activityIndicator)
        
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
        
        label.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(titleView)
            maker.centerY.equalTo(titleView)
        }
        
        loginField.snp.makeConstraints { (maker) in
            maker.left.equalTo(background).offset(15)
            maker.right.equalTo(background).offset(-15)
            maker.top.equalTo(view.bounds.height / 3)
            maker.height.equalTo(40)
        }
        
        loginSeparatorView.snp.makeConstraints { (maker) in
            maker.top.equalTo(loginField.snp.bottom)
            maker.height.equalTo(3)
            maker.left.equalTo(background).offset(15)
            maker.right.equalTo(background).offset(15)
        }
        
        passwordField.snp.makeConstraints { (maker) in
            maker.left.equalTo(background).offset(15)
            maker.right.equalTo(background).offset(-15)
            maker.top.equalTo(loginSeparatorView.snp.bottom).offset(10)
            maker.height.equalTo(40)
        }
        
        passwordSeparatorView.snp.makeConstraints { (maker) in
            maker.top.equalTo(passwordField.snp.bottom)
            maker.height.equalTo(3)
            maker.left.equalTo(background).offset(15)
            maker.right.equalTo(background).offset(15)
        }
        
        loginButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(passwordSeparatorView.snp.bottom).offset(15)
            maker.height.equalTo(50)
            maker.centerX.equalTo(background)
        }
        
        activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(background)
            maker.centerY.equalTo(background)
        }
    }
    
    @objc func didTapLoginButton() {
        if let login = loginField.text,
           let password = passwordField.text {
            presenter.onloginButton(login: login, password: password)
        }
    }
}

extension LoginViewController: LoginViewProtocol {
    func loginStatus(status: Bool) {
        activityIndicator.stopAnimating()
        loginButton.isUserInteractionEnabled = true
        loginField.isUserInteractionEnabled = true
        passwordField.isUserInteractionEnabled = true

        switch status {
        case true:
            self.presenter.onTimeTableGroup()
        case false:
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        loginButton.isUserInteractionEnabled = false
        loginField.isUserInteractionEnabled = false
        passwordField.isUserInteractionEnabled = false
    }
    
    func openTimeTableGroup(_ presenter: TimeTableGroupPresenterProtocol) {
        let vc = TimeTableGroupViewController(presenter: presenter)
        navigationController?.pushViewController(vc,animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        switch textField.tag {
        case 0:
            return newLength <= 30
        default:
            return newLength <= 12
        }
    }
}
