//
//  SignInView.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 10.05.2025.
//

import SwiftUI

struct SignInView: View {
    @StateObject var vm: SignInViewModel
    @AppStorage("userEmail") private var email = ""
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
                Button("Sign In") { vm.signIn(email: email, password: password) }
                    .buttonStyle(.borderedProminent)
                HStack {
                    Text("New here?")
                        .foregroundColor(.gray)
                    Button("Sign Up") {vm.showSignUp()}
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
    let viewModel = SignInViewModel(router: Router(navigationController: UINavigationController()))
    SignInView(vm: viewModel)
}
