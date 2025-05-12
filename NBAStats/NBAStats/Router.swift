//
//  Router.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 10.05.2025.
//

import UIKit
import SwiftUI

final class Router {
    var rootViewController: UINavigationController?
    
    init (navigationController: UINavigationController) {
        self.rootViewController = navigationController
    }
    
    @MainActor
    func start() {
        if AuthService.shared.isSignedIn {
            navigateGameDay()
        }
        else {
            navigateSignIn()
        }
    }
    
    @MainActor
    func navigateSignIn() {
        let signInViewModel = SignInViewModel(router: self)
        let signInView = SignInView(vm: signInViewModel)
        let signInVC = UIHostingController(rootView: signInView)
        rootViewController?.setViewControllers([signInVC], animated: true)
    }
    
    @MainActor
    func navigateSignUp(){
        let signUpViewModel = SignUpViewModel(router: self)
        let signUpView = SignUpView(vm: signUpViewModel)
        let signUpVC = UIHostingController(rootView: signUpView)
        rootViewController?.setViewControllers([signUpVC], animated: true)
    }

    @MainActor
    func navigateGameDay() {
        let gameDayViewModel = GameDayViewModel(router: self)
        let gameDayView = GameDayView(viewModel: gameDayViewModel)
        let gameDayViewController = UIHostingController(rootView: gameDayView)
        rootViewController?.setViewControllers([gameDayViewController], animated: false)
    }
    
    @MainActor
    func navigateStandings() {
        let standingsViewModel = StandingsViewModel(router: self)
        let standingsView = StandingsView(viewModel: standingsViewModel)
        let standingsViewController = UIHostingController(rootView: standingsView)
        rootViewController?.setViewControllers([standingsViewController], animated: false)
    }
    
    @MainActor
    func navigateGameDetail(gameId: String){
        let gameDetailViewModel = GameDetailViewModel(router: self)
        let gameDetailView = GameDetailView(viewModel: gameDetailViewModel, gameId: gameId)
        let gameDetailViewController = UIHostingController(rootView: gameDetailView)
        rootViewController?.setViewControllers([gameDetailViewController], animated: true)
        
    }
}
