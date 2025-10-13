import SwiftUI

struct OnBoardingButton: View {
    let title: String
    let action: () -> Void
    var backgroundColor: Color = .green
    var textColor: Color = .black
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(15)
                .font(.headline)
        }
        .padding(.horizontal, 20)
    }
}
