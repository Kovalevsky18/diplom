//
//  BroadcastViewPresenter.swift
//  MMFTimeTable
//
//  Created by mac on 30.05.21.
//

import Foundation

protocol BroadcastViewProtocol: AnyObject {
    func loadUrl(url: String)
    func loadTitle(title: String)
}

protocol BroadcastPresenterProtocol: AnyObject {
    func attachView(_ view: BroadcastViewProtocol)
}

final class BroadcastPresenter {
    private weak var view: BroadcastViewProtocol?
    
    private var url: String
    private var title: String
    
    init(url: String, title: String) {
        self.url = url
        self.title = title
    }
}

extension BroadcastPresenter: BroadcastPresenterProtocol {
    func attachView(_ view: BroadcastViewProtocol) {
        self.view = view
        loadURL()
        loadTitle()
    }
}

private extension BroadcastPresenter {
    func loadURL() {
        view?.loadUrl(url: url)
    }
    
    func loadTitle() {
        view?.loadTitle(title: title)
    }
}
