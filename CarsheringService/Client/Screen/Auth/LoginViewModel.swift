import Foundation
import Combine // <- обязательно
// SwiftUI импорту не обязательно здесь, но можно добавить

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String?

    private let authService = AuthService()

    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                _ = try self.authService.login(email: self.email, password: self.password)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
}
