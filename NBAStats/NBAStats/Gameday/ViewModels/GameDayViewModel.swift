//
//  GameDayViewModel.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 11.05.2025.
//
import Foundation
import SwiftUI

let env = ProcessInfo.processInfo.environment

@MainActor
final class GameDayViewModel: ObservableObject {
    @Published var gameDay: GameDayModel?
    @Published var errorMessage: ErrorMessage?
    
    private let apiKey = env["API-KEY"] ?? ""
    private var router: Router
    
    init (router: Router) {
        self.router = router
    }
    
    func showStandings(){
        router.navigateStandings()
    }
    
    func showSignIn(){
        router.navigateSignIn()
    }
    
    func signOut() {
        do {
            try AuthService.shared.signOut()
        } catch {
            errorMessage?.message = error.localizedDescription
        }
        
    }
    
    
    private func makeURL(for date: Date) -> URL? {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month, .day], from: date)
        guard let y = comps.year, let m = comps.month, let d = comps.day else { return nil }
        
        let path = String(format:
                            "https://api.sportradar.com/nba/trial/v8/en/games/%04d/%02d/%02d/schedule.json",
                          y, m, d
        )
        let url = URL(string: path)
        return url
    }
    
    func getGameDay(for date: Date) async {
        gameDay      = nil
        
        guard let url = makeURL(for: date) else { return }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.timeoutInterval = 10
        req.setValue("application/json", forHTTPHeaderField: "accept")
        req.setValue(apiKey,               forHTTPHeaderField: "x-api-key")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: req)
            gameDay       = try JSONDecoder().decode(GameDayModel.self, from: data)
        } catch {
            self.errorMessage  = .init(message: error.localizedDescription)
        }
    }
    
    func showGameDetail(gameId: String) {
        router.navigateGameDetail(gameId: gameId)
    }
}

