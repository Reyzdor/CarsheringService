import SwiftUI

struct LoginView_Unique: View {
    @StateObject private var vm = LoginViewModel()
    @State private var goToMain = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Вход").font(.largeTitle).bold()

            TextField("Email", text: $vm.email)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).strokeBorder())

            SecureField("Пароль", text: $vm.password)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).strokeBorder())

            if let err = vm.error {
                Text(err).foregroundColor(.red).multilineTextAlignment(.center)
            }

            Button("Войти") {
                vm.login { result in
                    switch result {
                    case .success:
                        goToMain = true
                    case .failure:
                        break
                    }
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)

            NavigationLink("", isActive: $goToMain) {
                MainView() // твой экран с картой
            }
        }
        .padding()
    }
}

struct LoginView_Previews_Unique: PreviewProvider {
    static var previews: some View {
        LoginView_Unique()
    }
}
