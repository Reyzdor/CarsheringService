import SwiftUI

struct BookingCardView: View {
    var car: CarEntity
    var bookingDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(car.brand)
                .font(.title2)
                .bold()
            Text("Бронировано: \(bookingDate.formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(car.isBooked ? "Статус: Занята" : "Статус: Свободна")
                .foregroundColor(car.isBooked ? .red : .green)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
