import Combine
import FirebaseAuth

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var router: Router
    
    init(router: Router) {
        self.user = AuthService.shared.user
        self.router = router
    }
    
    func signUp(email: String, password: String) {
        Task {
            do {
               let u = try await AuthService.shared.signUp(email: email, password: password)
                await MainActor.run {
                    self.user = u
                    self.router.navigateGameDay()
                }
                router.navigateGameDay()
            }
        }
    }
    
    func showSignIn() {
        router.navigateSignIn()
    }
    
    private func execute(_ block: () async throws -> User) async {
        isLoading = true
        defer { isLoading = false }
        do { user = try await block() }
        catch { errorMessage = error.localizedDescription }
    }
}
