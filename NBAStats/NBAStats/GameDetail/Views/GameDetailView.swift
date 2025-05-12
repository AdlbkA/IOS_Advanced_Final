//
//  GameDetailView.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 12.05.2025.
//

import SwiftUI

struct GameDetailView: View {
    @StateObject var viewModel: GameDetailViewModel
    var gameId : String
    
    var body: some View {
        HStack {
            Button("Back", systemImage: "chevron.left") {
                viewModel.showHome()
            }
            Spacer()
        }
        .padding(.leading, 15)
        
        VStack(alignment: .leading, spacing: 24) {
            
            if let g = viewModel.gameDetails {
                Header(game: g)
                
                Text("Team Stats")
                    .font(.headline)
                
                StatRow(home: pct(g.home.statistics.field_goals_pct),
                        label: "Field Goals",
                        away: pct(g.away.statistics.field_goals_pct))
                
                StatRow(home: pct(g.home.statistics.three_points_pct),
                        label: "3 Pointers",
                        away: pct(g.away.statistics.three_points_pct))
                
                StatRow(home: pct(g.home.statistics.free_throws_pct),
                        label: "Free Throws",
                        away: pct(g.away.statistics.free_throws_pct))
                
                StatRow(home: "\(g.home.statistics.total_rebounds)",
                        label: "Rebounds",
                        away: "\(g.away.statistics.total_rebounds)")
                
                StatRow(home: "\(g.home.statistics.assists)",
                        label: "Assists",
                        away: "\(g.away.statistics.assists)")
                
            }
            else if let err = viewModel.errorMessage {
                Text("Game hasn't finished yet. Come back later")
            }
            else {
                ProgressView()
            }
            
            if let leaders = viewModel.gameLeaders {
                PlayerStatsBlock(leaders: leaders,
                                 homeName: viewModel.gameDetails?.home.name ?? "Home",
                                 awayName: viewModel.gameDetails?.away.name ?? "Away")
            }
            
            Spacer()
            
            
        }
        .padding()
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getGameDetail(gameId: gameId)
            await viewModel.getGameLeaders(gameId: gameId)
        }
    }
    
    private func pct(_ v: Double) -> String {
        let value = v <= 1 ? v * 100 : v
        return String(format: "%.1f%%", value)
    }
}

private struct Header: View {
    let game: GameDetailModel
    
    var body: some View {
        VStack(spacing: 4) {
            
            HStack(spacing: 16) {
                
                AsyncLogo(url: game.home.image)
                
                Text("\(game.home.points)")
                    .font(.title.bold())
                
                VStack(spacing: 2) {
                    Text("Final").bold()
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text("\(game.away.points)")
                    .font(.title.bold())
                
                AsyncLogo(url: game.away.image)
            }
            
            HStack {
                Text(game.home.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(game.away.name)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(.subheadline)
            .padding(.top, 4)
        }
    }
    
    private var formattedDate: String {
        let iso = ISO8601DateFormatter()
        guard let date = iso.date(from: game.scheduled) else { return "" }
        return date.formatted(.dateTime.month(.abbreviated).day().year())
    }
}

private struct StatRow: View {
    let home: String
    let label: String
    let away: String
    
    var body: some View {
        HStack {
            Text(home)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(label)
                .frame(maxWidth: .infinity)
            
            Text(away)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.body)
    }
}

private struct AsyncLogo: View {
    let url: URL
    var body: some View {
        AsyncImage(url: url) { phase in
            if case .success(let img) = phase { img.resizable() } else { Color.clear }
        }
        .frame(width: 48, height: 48)
    }
}


private struct PlayerStatsBlock: View {
    let leaders: GameLeadersModel
    let homeName: String
    let awayName: String

    @State private var side: Side = .home
    enum Side: String, CaseIterable { case home, away }

    private var lists: (points:[Points], rebounds:[Rebounds], assists:[Assists]) {
        let l = side == .home ? leaders.home.leaders : leaders.away.leaders
        return (l.points, l.rebounds, l.assists)
    }

    private struct Row: Identifiable {
        let id = UUID()
        let label: String
        let name:  String
        let pts, reb, ast: Int
    }

    private var rows: [Row] {
        var out: [Row] = []


        if let p = lists.points.first {
            out.append(Row(label:"PTS", name: p.full_name,
                           pts: p.statistics.points,
                           reb: p.statistics.rebounds,
                           ast: p.statistics.assists))
        }

        if let r = lists.rebounds.first {
            out.append(Row(label:"REB", name: r.full_name,
                           pts: r.statistics.points,
                           reb: r.statistics.rebounds,
                           ast: r.statistics.assists))
        }
    
        if let a = lists.assists.first {
            out.append(Row(label:"AST", name: a.full_name,
                           pts: a.statistics.points,
                           reb: a.statistics.rebounds,
                           ast: a.statistics.assists))
        }
        return out
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack {
                Text("Player Stats").font(.headline)
                Spacer()
                Menu { Button(homeName) { side = .home }
                       Button(awayName) { side = .away } }
                label: {
                    Label(side == .home ? homeName : awayName,
                          systemImage: "chevron.down")
                        .labelStyle(.titleOnly)
                        .font(.subheadline.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .overlay(RoundedRectangle(cornerRadius: 4)
                                  .stroke(Color.secondary, lineWidth: 1))
                }
            }

    
            ForEach(rows) { row in
                HStack(spacing: 12) {
                    Text(row.label)
                        .font(.caption.bold())
                        .frame(width: 40, alignment: .leading)

                    Text(row.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)

                    stat(row.pts, "PTS")
                    stat(row.reb, "REB")
                    stat(row.ast, "AST")
                }
                .padding(.vertical, 4)
                .overlay(Divider(), alignment: .bottom)
            }
        }
        .padding(.top, 24)
    }

    private func stat(_ val: Int, _ lbl: String) -> some View {
        VStack {
            Text("\(val)").fontWeight(.semibold)
            Text(lbl).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(width: 46)
    }
}



#Preview {
    let viewModel = GameDetailViewModel(router: Router(navigationController: UINavigationController()))
    GameDetailView(viewModel: viewModel, gameId: "36497a74-1b93-4891-9312-3c30c60986f5")
}
