//
//  TimeTableGroupModel.swift
//  MMFTimeTable
//
//  Created by mac on 28.05.21.
//

import Foundation

struct TimeTableGroupModel {
    let title: String
    let url: String
    let days: [TimeTableGroupDay]
}

struct TimeTableGroupDay {
    let day: String
    let lessons: [TimeTableGroupLessons]
}

struct TimeTableGroupLessons {
    let title: String
    let subtitle: String
}

struct TimeTableViewModel {
    let title: String
    let day: String
    let lessons: [TimeTableGroupLessons]
}
