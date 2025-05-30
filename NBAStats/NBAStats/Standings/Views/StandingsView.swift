//
//  StandingsView.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 11.05.2025.
//

import SwiftUI

struct StandingsView: View {
    @StateObject var viewModel: StandingsViewModel
    
    @State private var selectedIndex: Int = 0
    
    private var conferences: [Conference] {
        viewModel.standings?.conferences ?? []
    }
    private var currentTeams: [Team] {
        guard conferences.indices.contains(selectedIndex) else { return [] }
        return conferences[selectedIndex]
            .divisions
            .flatMap(\.teams)
            .sorted { $0.win_pct > $1.win_pct }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if !conferences.isEmpty {
                Picker("Conference", selection: $selectedIndex) {
                    ForEach(conferences.indices, id: \.self) { idx in
                        Text(conferences[idx].alias.capitalized)
                            .tag(idx)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
            }
            
            if !currentTeams.isEmpty {
                header
                    .padding(.horizontal)
            }
            
            List(Array(currentTeams.enumerated()), id: \.1.name) { index, team in
                HStack {
                    Text("\(index + 1)")
                        .frame(width: 24, alignment: .trailing)
                        .foregroundStyle(.secondary)
                    
                    Text(team.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(team.wins)")
                        .frame(width: 32, alignment: .trailing)
                    Text("\(team.losses)")
                        .frame(width: 32, alignment: .trailing)
                    Text(String(format: "%.3f", team.win_pct))
                        .frame(width: 48, alignment: .trailing)
                }
                .font(.body)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Standings")
        .task {
            await viewModel.getStandings()
        }
        
        HStack(spacing: 0) {
            
            VStack {
                Image(systemName: "house")
                Text("Home")
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { viewModel.showHome() }
            
            
            VStack {
                Image(systemName: "trophy.fill")
                Text("Standings")
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            
            
            
            VStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign out")
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.signOut()
                viewModel.showSignIn()
            }
        }
        .foregroundColor(.black)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.15))
        
    }
    
    private var header: some View {
        HStack {
            Text("Team")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("W")
                .frame(width: 32, alignment: .trailing)
            
            Text("L")
                .frame(width: 32, alignment: .trailing)
            
            Text("PCT")
                .frame(width: 48, alignment: .trailing)
        }
        .font(.subheadline.bold())
        .foregroundStyle(.secondary)
    }
    
    
}

#Preview {
    let viewModel = StandingsViewModel(router: Router(navigationController: UINavigationController()))
    StandingsView(viewModel: viewModel)
}
