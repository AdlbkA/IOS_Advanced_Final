//
//  GameDetailModel.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 12.05.2025.
//

import Foundation
import SwiftUI

struct GameDetailModel: Decodable {
    let id: String
    let home: HomeTeam
    let away: AwayTeam
    let scheduled: String
}

struct HomeTeam: Decodable {
    let name: String
    let alias: String
    var image: URL {
        URL(string: "https://a.espncdn.com/combiner/i?img=/i/teamlogos/nba/500/\(alias.lowercased()).png&h=200&w=200")!
    }
    let statistics: Statistics
    let points: Int
}

struct AwayTeam: Decodable {
    let name: String
    let alias: String
    var image: URL {
        URL(string: "https://a.espncdn.com/combiner/i?img=/i/teamlogos/nba/500/\(alias.lowercased()).png&h=200&w=200")!
    }
    let statistics: Statistics
    let points: Int
}

struct Statistics: Decodable {
    let field_goals_pct: Double
    let three_points_pct: Double
    let free_throws_pct: Double
    let total_rebounds: Int
    let assists: Int
}
