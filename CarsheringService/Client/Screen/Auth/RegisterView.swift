import SwiftUI

struct RegisterView: View {
    @StateObject private var vm = RegisterViewModel()
    @State private var goToMain = false

    @AppStorage("didOnboard") private var didOnboard: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Регистрация")
                .font(.largeTitle).bold()

            Group {
                TextField("Email", text: $vm.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)

                SecureField("Пароль", text: $vm.password)
                TextField("Имя", text: $vm.name)
                TextField("Телефон", text: $vm.phone)
                    .keyboardType(.phonePad)
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 8).strokeBorder())
            .padding(.horizontal)

            if let err = vm.errorMessage {
                Text(err).foregroundColor(.red).multilineTextAlignment(.center)
            }

            Button(action: {
                vm.register { result in
                    switch result {
                    case .success:
                        didOnboard = true
                        goToMain = true
                    case .failure:
                        break
                    }
                }
            }) {
                if vm.isLoading {
                    ProgressView()
                } else {
                    Text("Зарегистрироваться")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor.opacity(0.8)))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 30)
        .navigationDestination(isPresented: $goToMain) {
            MainView() 
        }
    }
}
