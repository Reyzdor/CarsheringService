import SwiftUI
import CoreData

struct BookingView: View {
    @State private var user: UserEntity?
    @State private var lastBooking: BookingEntity?

    private let bookingService = BookingService()

    var body: some View {
        VStack {
            if let booking = lastBooking, let car = booking.car {
                BookingCardView(car: car, bookingDate: booking.bookSession)
            } else {
                Text("У вас нет активных бронирований")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            if let user = user {
                lastBooking = bookingService.getLastBooking(for: user)
            }
        }
        .padding()
    }
}
