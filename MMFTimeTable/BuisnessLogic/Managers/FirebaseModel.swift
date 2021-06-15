//
//  FirebaseModel.swift
//  MMFTimeTable
//
//  Created by mac on 28.05.21.
//

import Foundation

struct FirebaseModel: Codable {
    let course: String
    let userID: String
    let group: String
    let name: String
    let url: String
    let days: [FirebaseDays]
}

struct FirebaseDays: Codable {
    let day: String
    let lesson: [FirebaseLessons]
}

struct FirebaseLessons: Codable {
    let title: String
    let subtitle: String
}
