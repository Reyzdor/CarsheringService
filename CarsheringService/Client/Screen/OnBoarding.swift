import SwiftUI

struct OnBoarding: View {
    @Binding var hasCompetedBoarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            ZStack {
                Color(red: 0.75, green: 0.15, blue: 1.0)
                    .ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        ForEach(0..<3, id:\.self) { index in
                            Capsule()
                                .frame(width: currentPage == index ? 30 : 15, height: 8)
                                .foregroundColor(currentPage == index ? .white : .gray.opacity(0.5))
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    Text("Бронируйте за две минуты")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    OnBoardingButton(
                        title: "Далее",
                        action: {
                            currentPage = 1
                        },
                        backgroundColor: Color(red: 0.0, green: 1.0, blue: 0.0),
                        showArrow: true
                    )
                    .padding(.bottom, 20)
                    Text("Нажимая на кнопку, вы принимаете условия пользовательского соглашения и политики конфиденциальности")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 18)
                        .frame(maxWidth: .infinity)
                }
            }
            .tag(0)
            
            ZStack {
                Color(red: 0.75, green: 0.15, blue: 1.0)
                    .ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        ForEach(0..<3, id:\.self) { index in
                            Capsule()
                                .frame(width: currentPage == index ? 30 : 15, height: 8)
                                .foregroundColor(currentPage == index ? .white : .gray.opacity(0.5))
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    Text("Б1")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    OnBoardingButton(
                        title: "Далее",
                        action: {
                            currentPage = 2
                        },
                        backgroundColor: Color(red: 0.0, green: 1.0, blue: 0.0),
                        showArrow: true
                    )
                   
                    .padding(.bottom, 20)
                    Text("Нажимая на кнопку, вы принимаете условия пользовательского соглашения и политики конфиденциальности")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 18)
                        .frame(maxWidth: .infinity)
                }
            }
            .tag(1)
            
            ZStack {
                Color(red: 0.75, green: 0.15, blue: 1.0)
                    .ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        ForEach(0..<3, id:\.self) { index in
                            Capsule()
                                .frame(width: currentPage == index ? 30 : 15, height: 8)
                                .foregroundColor(currentPage == index ? .white : .gray.opacity(0.5))
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    Text("FSDSDF")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    OnBoardingButton(
                        title: "Начать пользоваться",
                        action: {
                            hasCompetedBoarding = true
                        },
                        backgroundColor: Color(red: 0.0, green: 1.0, blue: 0.0),
                        showArrow: false
                    )
                    .padding(.bottom, 20)
                    Text("Нажимая на кнопку, вы принимаете условия пользовательского соглашения и политики конфиденциальности")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 18)
                        .frame(maxWidth: .infinity)
                }
            }
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.all)
    }
}
