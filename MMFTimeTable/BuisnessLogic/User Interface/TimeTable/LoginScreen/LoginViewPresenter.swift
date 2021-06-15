//
//  LoginViewPresenter.swift
//  MMFTimeTable
//
//  Created by Родион Ковалевский on 4/19/21.
//

import Foundation

protocol LoginViewProtocol: AnyObject {
    func loginStatus(status: Bool)
    func showActivityIndicator()
    func openTimeTableGroup(_ presenter: TimeTableGroupPresenterProtocol)
}

protocol LoginPresenterProtocol: AnyObject {
    func attachView(_ view: LoginViewProtocol)
    func onloginButton(login: String, password: String)
    func onTimeTableGroup()
}

final class LoginViewPresenter {
    private weak var view: LoginViewProtocol?

    private let fireBaseManager: FireBaseManagerProtocol = FireBaseManager()
    
    private var userID: String = ""

    init() {
    }
}

extension LoginViewPresenter: LoginPresenterProtocol {
    func attachView(_ view: LoginViewProtocol) {
        self.view = view
    }
    
    func onTimeTableGroup() {
        let presenter = TimeTableGroupPresenter(userID: userID)
        view?.openTimeTableGroup(presenter)
    }
    
    func onloginButton(login: String, password: String) {
        view?.showActivityIndicator()

        fireBaseManager.auth(login: login, password: password) { result in
            switch result {
            case .success(let userID):
                self.userID = userID
                self.view?.loginStatus(status: true)
            case .failure(_):
                self.view?.loginStatus(status: false)
            }
        }
    }
}

