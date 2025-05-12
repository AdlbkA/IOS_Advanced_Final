//
//  GameDayView.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 11.05.2025.
//

import SwiftUI

struct GameDayView: View {
    @StateObject var viewModel: GameDayViewModel
    @State       private var selectedDate = Date()
    
    var body: some View {
        HStack{
            
        }
        
        
        VStack(spacing: 0) {
            
            Text("NBA Scores")
                .font(.headline)
            
            DateHeader(date: $selectedDate)
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    if let games = viewModel.gameDay?.games {
                        ForEach(games, id: \.id) { game in
                            GameCard(game: game)
                                .onTapGesture {
                                    viewModel.showGameDetail(gameId: game.id)
                                }
                        }
                    } else if let error = viewModel.errorMessage {
                        Text(error.message)
                            .foregroundStyle(.red)
                            .padding(.top, 40)
                    } else {
                        ProgressView()
                            .padding(.top, 60)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            HStack{
                Button("Home") {}
                
                    .padding(.leading, 35.0)
                
                
                Spacer()
                
                Button("Standings") {
                    viewModel.showStandings()
                }
                
                
                Spacer()
                
                Button ("Sign out") {
                    viewModel.signOut()
                    viewModel.showSignIn()
                }
                .padding(.trailing, 35.0)
               
            }
            
            
        }
        
        .task(id: selectedDate) {
            await viewModel.getGameDay(for: selectedDate)}
        
    }
}

#Preview {
    let vm = GameDayViewModel(router: Router(navigationController: UINavigationController()))
    GameDayView(viewModel: vm)
}

private struct GameCard: View {
    let game: Games
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ScoreLine(logoURL: game.home.image,
                      teamName: game.home.name,
                      points:   game.home_points)
            
            ScoreLine(logoURL: game.away.image,
                      teamName: game.away.name,
                      points:   game.away_points)
            
            
            Text("Final · \(game.venue.name)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 52)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        )
        
    }
}

private struct ScoreLine: View {
    let logoURL: URL
    let teamName: String
    let points: Int?
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: logoURL) { phase in
                if case .success(let image) = phase {
                    image.resizable()
                } else {
                    Color.clear
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            Text(teamName)
                .font(.body)
            
            Spacer()
            
            Text(points?.description ?? "—")
                .font(.title3.weight(.bold))
        }
    }
}

private struct DateHeader: View {
    @Binding var date: Date
    
    var body: some View {
        
        let calendar    = Calendar.current
        let displayDate = calendar.date(byAdding: .day, value: 1, to: date)!
        let label       = displayDate.formatted(.dateTime.month(.wide).day().year())
        
        HStack {
            Button {
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            } label: {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(label)
                .font(.headline)
            
            Spacer()
            
            Button {
                date = Calendar.current.date(byAdding: .day, value:  1, to: date)!
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
    }
}
