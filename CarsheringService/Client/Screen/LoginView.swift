import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Вход в каршеринг")
                .font(.title)
                .bold()
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
            
            
            SecureField("Пароль", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .textContentType(.password)
            
            Button("Войти") {
                attemptLogin()
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty)
            
            .font(.caption)
            .multilineTextAlignment(.center)
            .foregroundColor(.gray)
        }
        .padding()
        .alert("Ошибка", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func attemptLogin() {
        let loginSuccess = authManager.login(email: email, password: password)
        
        if loginSuccess {
            
        } else {
            errorMessage = "Неверный логин или пароль"
            showError = true
        }
    }
}
