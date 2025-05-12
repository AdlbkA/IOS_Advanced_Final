//
//  StandingsModel.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 11.05.2025.
//

import SwiftUI
import Foundation

struct StandingsModel: Decodable {
    let conferences: [Conference]
}

struct Conference: Decodable {
    let alias: String
    let divisions: [Division]
}

struct Division: Decodable {
    let teams: [Team]
}

struct Team: Decodable, Identifiable {
    var id = UUID()
    let name: String
    let wins: Int
    let losses: Int
    let win_pct: Double
    
}
