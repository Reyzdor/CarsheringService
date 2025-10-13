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
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.90, green: 0.30, blue: 1.0))
                        .stroke(Color.white, lineWidth: 0)
                        .frame(width: 350, height: 280)
                        .offset(y: -20)
                        .overlay(
                            VStack(spacing: 10) {
                                Circle()
                                    .fill(Color(red: 0.0, green: 1.0, blue: 0.0))
                                    .frame(width: 100, height: 90)
                                    .overlay(
                                        Image("pin2")
                                            .resizable()
                                            .offset(y: 3)
                                            .frame(width: 50, height: 50)
                                    )
                                    .padding(10)
                                
                                Text("Найдите автомобиль рядом")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                    .padding(10)
                                
                                Text("Тысячи автомобилей доступны в вашем городе.\nВыберите ближайший и отправляйтесь в путь!")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding(.horizontal, 20)
                            }
                            .offset(y: -50)
                        )
                    
                    HStack(spacing: 25){
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.90, green: 0.30, blue: 1.0))
                            .stroke(Color.white, lineWidth: 0)
                            .frame(width: 100, height: 200)
                            .overlay(
                                VStack {
                                    Image("security")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .offset(y: -30)
                                        .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))
                                    
                                        .padding(10)

                                    
                                    Text("Безопасность")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .offset(y: -20)
                                    
                                    Text("Автомобили\nзастрахованы")
                                        .font(.system(size: 10))
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                                
                            )
                        
                        HStack(spacing: 25) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.90, green: 0.30, blue: 1.0))
                                .stroke(Color.white, lineWidth: 0)
                                .frame(width: 100, height: 200)
                                .overlay(
                                    VStack {
                                        Image("star")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .offset(y: -30)
                                            .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))
                                        
                                            .padding(10)

                                        
                                        Text("Качество")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .offset(y: -20)
                                        
                                        Text("Проверенные\nавто")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.7))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                    }
                                )
                        }
                        
                        HStack(spacing: 25) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.90, green: 0.30, blue: 1.0))
                                .stroke(Color.white, lineWidth: 0)
                                .frame(width: 100, height: 200)
                                .overlay(
                                    VStack {
                                        Image("flash")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .offset(y: -30)
                                            .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))
                                            
                                            .padding(10)
                                        
                                        Text("Быстро")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .offset(y: -20)
                                        
                                        Text("Открытие за\n30 секунд")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.7))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                        
                                        
                                    }
                                )
                        }
                    }
                    
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
