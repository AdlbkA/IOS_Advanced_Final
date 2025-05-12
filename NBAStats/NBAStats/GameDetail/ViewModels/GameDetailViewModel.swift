//
//  GameDetailViewModel.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 12.05.2025.
//

import Foundation
import SwiftUI

@MainActor
final class GameDetailViewModel: ObservableObject {
    @Published var gameDetails: GameDetailModel?
    @Published var gameLeaders: GameLeadersModel?
    @Published var errorMessage: ErrorMessage?
    
    private var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func showHome(){
        router.navigateGameDay()
    }
    
    func getGameDetail(gameId: String) async {
        let url = URL(string: "https://api.sportradar.com/nba/trial/v8/en/games/\(gameId)/summary.json")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-api-key": "pmJQFmc0511nIDGDxj1Eh3PptaP6ryh3eLkDTx4j"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let gameDetail = try JSONDecoder().decode(GameDetailModel.self, from: data)
            
            await MainActor.run {
                gameDetails = gameDetail
            }
        }
        catch {
            await MainActor.run {
                self.errorMessage = ErrorMessage(message: "Unexpected error: \(error.localizedDescription)")
            }
        }
    }
    
    func getGameLeaders(gameId: String) async {
        let url = URL(string: "https://api.sportradar.com/nba/trial/v8/en/games/\(gameId)/boxscore.json")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-api-key": "pmJQFmc0511nIDGDxj1Eh3PptaP6ryh3eLkDTx4j"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let gameLeader = try JSONDecoder().decode(GameLeadersModel.self, from: data)
            
            await MainActor.run {
                gameLeaders = gameLeader
            }
        }
        catch {
            await MainActor.run {
                self.errorMessage = ErrorMessage(message: "Unexpected error: \(error.localizedDescription)")
            }
        }
    }
}
