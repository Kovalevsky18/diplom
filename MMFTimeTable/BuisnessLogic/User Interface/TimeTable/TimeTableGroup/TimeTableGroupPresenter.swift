//
//  TimeTableGroupPresenter.swift
//  MMFTimeTable
//
//  Created by mac on 6.05.21.
//

import Foundation

protocol TimeTableGroupViewProtocol: AnyObject {
    func updateItems(data: TimeTableViewModel)
    func openBroadcasts(_ presenter: BroadcastPresenterProtocol)
}

protocol TimeTableGroupPresenterProtocol: AnyObject {
    func attachView(_ view: TimeTableGroupViewProtocol)
    func fetchData()
    func changeContent(with index: Int)
    func onBroadcasts(_ index: Int)
}

final class TimeTableGroupPresenter {
    private weak var view: TimeTableGroupViewProtocol?
    
    private let fireBaseManager: FireBaseManagerProtocol = FireBaseManager()
    
    private var data: TimeTableGroupModel? {
        didSet {
            configureViewModel(day: currentDay)
        }
    }
    
    private var viewModel: TimeTableViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            view?.updateItems(data: viewModel)
        }
    }
    
    private var currentDay = 0 {
        didSet {
            configureViewModel(day: currentDay)
        }
    }
    
    private var userID: String
    
    init(userID: String) {
        self.userID = userID
    }
}

extension TimeTableGroupPresenter: TimeTableGroupPresenterProtocol {
    func attachView(_ view: TimeTableGroupViewProtocol) {
        self.view = view
    }
    
    func onBroadcasts(_ index: Int) {
        guard let url = data?.url, 
              let title = viewModel?.lessons[safe: index]?.title 
        else { return }
        
        let presenter = BroadcastPresenter(url: url, 
                                           title: title)
        view?.openBroadcasts(presenter)
    }
    
    func fetchData() {
        fireBaseManager.fetch(userID: userID) { [weak self] result in
            switch result {
            case .success(let response):
                self?.configureData(from: response)
            case .failure(_):
                break
            }
        }
    }
    
    func changeContent(with index: Int) {
        currentDay = index
    }
}

private 
extension TimeTableGroupPresenter {
    func configureData(from response: FirebaseModel) {
        let title = "\(response.name)\n\(response.course) курс \(response.group) группа"
        let dayModel = response.days.compactMap { (item) -> TimeTableGroupDay in
            let lessonsModel = item.lesson.compactMap { (lesson) -> TimeTableGroupLessons in
                return TimeTableGroupLessons(title: lesson.title,
                                             subtitle: lesson.subtitle)
            }
            return TimeTableGroupDay(day: item.day, lessons: lessonsModel)
        }
        data = TimeTableGroupModel(
            title: title,
            url: response.url,
            days: dayModel
        )
    }
    
    func configureViewModel(day: Int) {
        guard let data = data,
              let currentDataSource = data.days[safe: day]
        else {
            return
        }
        
        let lessons = currentDataSource.lessons.compactMap { (lessons) -> TimeTableGroupLessons in
            return TimeTableGroupLessons(title: lessons.title,
                                         subtitle: lessons.subtitle)
        }
        viewModel = TimeTableViewModel(title: data.title,
                                       day: currentDataSource.day,
                                       lessons: lessons)
    }
} 

