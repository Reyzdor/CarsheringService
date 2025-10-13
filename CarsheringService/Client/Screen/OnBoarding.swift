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
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(currentPage == index ? .white : .gray)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    Text("Бронируйте за две минуты")
                    
                    Spacer()
                    
                    OnBoardingButton(
                        title: "Далее",
                        action: {
                            currentPage = 1
                        },
                        backgroundColor: Color(red: 0.0, green: 1.0, blue: 0.0),
                    )
                    .padding(.bottom, 50)
                }
            }
            .tag(0)
            .ignoresSafeArea(.all)
            
            ZStack {
                Color(red: 0.75, green: 0.15, blue: 1.0)
                    .ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        ForEach(0..<3, id:\.self) { index in
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(currentPage == index ? .white : .gray)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    Text("Б1")
                    
                    Spacer()
                    
                    OnBoardingButton(
                        title: "Далее",
                        action: {
                            currentPage = 2
                        },
                        backgroundColor: Color(red: 0.0, green: 1.0, blue: 0.0),
                    )
                    .padding(.bottom, 50)
                }
            }
            .tag(1)
            .ignoresSafeArea(.all)
            
            ZStack {
                Color(red: 0.75, green: 0.15, blue: 1.0)
                    .ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        ForEach(0..<3, id:\.self) { index in
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(currentPage == index ? .white : .gray)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    Text("FSDSDF")
                    
                    Spacer()
                    
                    OnBoardingButton(
                        title: "Начать использование",
                        action: {
                            hasCompetedBoarding = true
                        },
                        backgroundColor: Color(red: 0.0, green: 1.0, blue: 0.0),
                    )
                    .padding(.bottom, 50)
                }
            }
            .tag(2)
            .ignoresSafeArea(.all)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.all)
    }
}
