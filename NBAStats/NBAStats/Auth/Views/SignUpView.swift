//
//  AuthView.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 10.05.2025.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var vm: SignUpViewModel
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        Text("NBA Stats")
            .font(.title)
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            if vm.isLoading {
                ProgressView()
            } else {
                Button("Sign Up") { vm.signUp(email: email, password: password) }
                    .buttonStyle(.borderedProminent)
                HStack {
                    Text("Already a user?")
                        .foregroundColor(.gray)
                    Button("Sign In") {vm.showSignIn()}
                        
                }
                    
            }
            
            if let error = vm.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    let viewModel = SignUpViewModel(router: Router(navigationController: UINavigationController()))
    SignUpView(vm: viewModel)
}
