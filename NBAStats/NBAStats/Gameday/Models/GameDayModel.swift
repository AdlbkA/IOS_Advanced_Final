//
//  GameDayModel.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 11.05.2025.
//

import Foundation
import SwiftUI

struct GameDayModel: Decodable {
    let games: [Games]
}

struct Games: Decodable, Identifiable {
    let id: String
    let scheduled: String
    let home_points: Int?
    let away_points: Int?
    let home: Home
    let away: Away
    let venue: Venue
}

struct Venue: Decodable {
    let name: String
    let city: String
}

struct Home: Decodable {
    let name: String
    let alias: String
    var image: URL {
        URL(string: "https://a.espncdn.com/combiner/i?img=/i/teamlogos/nba/500/\(alias.lowercased()).png&h=200&w=200")!
    }
}

struct Away: Decodable {
    let name: String
    let alias: String
    var image: URL {
        URL(string: "https://a.espncdn.com/combiner/i?img=/i/teamlogos/nba/500/\(alias.lowercased()).png&h=200&w=200")!
    }
}
