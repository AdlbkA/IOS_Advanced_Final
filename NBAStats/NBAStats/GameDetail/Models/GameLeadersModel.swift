//
//  GameLeadersModel.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 12.05.2025.
//

struct GameLeadersModel: Decodable {
    let home: HomeLeaders
    let away: AwayLeaders
}

struct HomeLeaders: Decodable {
    let leaders: Leaders
}

struct AwayLeaders: Decodable {
    let leaders: Leaders
}

struct Leaders: Decodable {
    let points: [Points]
    let rebounds: [Rebounds]
    let assists: [Assists]
}

struct Points: Decodable {
    let full_name: String
    let statistics: LeadersStatistics
}

struct Rebounds: Decodable {
    let full_name: String
    let statistics: LeadersStatistics
}

struct Assists: Decodable {
    let full_name: String
    let statistics: LeadersStatistics
}

struct LeadersStatistics: Decodable {
    let points: Int
    let rebounds: Int
    let assists: Int
}
