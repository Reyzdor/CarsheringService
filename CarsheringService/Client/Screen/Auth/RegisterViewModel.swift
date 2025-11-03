import Foundation
import Combine

final class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let authService = AuthService()

    func register(completion: @escaping (Result<Void, Error>) -> Void) {
        errorMessage = nil

        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Заполните имя, email и пароль."
            completion(.failure(ValidationError.missingFields))
            return
        }

        guard email.contains("@") else {
            errorMessage = "Некорректный email."
            completion(.failure(ValidationError.invalidEmail))
            return
        }

        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                _ = try self.authService.register(name: self.name,
                                                  email: self.email,
                                                  phone: self.phone,
                                                  password: self.password)
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }

    enum ValidationError: Error {
        case missingFields
        case invalidEmail
    }
}
