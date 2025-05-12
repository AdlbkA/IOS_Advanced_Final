//
//  AuthService.swift
//  NBAStats
//
//  Created by Anuar Adilbek on 10.05.2025.


import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    var user: User? { Auth.auth().currentUser }
    
    var isSignedIn: Bool {Auth.auth().currentUser != nil}
    
    func signOut() throws {
            try Auth.auth().signOut()
        }
    
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await result.user.sendEmailVerification()
        return result.user
    }
    
    func signIn(email: String, password: String) async throws -> User {
       let result = try await Auth.auth().signIn(withEmail: email, password: password)
       return result.user
     }
}
