import Foundation
import Combine

class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isLogin = false
    
    func register(email: String, password: String, name: String, phone: String) -> Bool {
        
        return true
    }
    
    func login(email: String, password: String) -> Bool {
        if let savedUser = loadUser() {
            
            if savedUser.email == email && savedUser.password == password {
                currentUser = savedUser
                isLogin = true
                return true
            }
        }
        
        return false
    }
    
    func logout() {
        currentUser = nil
        isLogin = false
    }
    
    func loadUser() -> User? {
        let testUser = User(
                email: "test@mail.ru",
                password: "123456",
                name: "Иван Иванов",
                phone: "+79991234567"
            )
        
        return testUser
        
    }
}
