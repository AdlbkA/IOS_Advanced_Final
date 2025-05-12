//
//  StandingsViewModel.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 11.05.2025.
//
import Foundation
import SwiftUI

@MainActor
final class StandingsViewModel: ObservableObject {
    @Published var standings: StandingsModel?
    @Published var errorMessage: ErrorMessage?
    
    private var router: Router
    
    init (router: Router) {
        self.router = router
    }
    
    func showHome(){
        router.navigateGameDay()
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
    
    func getStandings() async {
        let url = URL(string: "https://api.sportradar.com/nba/trial/v8/en/seasons/2024/REG/standings.json")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-api-key": "pmJQFmc0511nIDGDxj1Eh3PptaP6ryh3eLkDTx4j"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let standing = try JSONDecoder().decode(StandingsModel.self, from: data)
            
            await MainActor.run {
                standings = standing
            }
        }
        catch {
            await MainActor.run {
                self.errorMessage = ErrorMessage(message: "Unexpected error: \(error.localizedDescription)")
            }
        }
    }
}
