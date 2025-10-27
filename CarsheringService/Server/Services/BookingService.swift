import Foundation
import CoreData

final class BookingService {
    private let context = CoreDataManager.shared.context

    func createBooking(for user: UserEntity, car: CarEntity) {
        let booking = BookingEntity(context: context)
        booking.bookSession = Date()
        booking.user = user
        booking.car = car
        car.isBooked = true

        CoreDataManager.shared.saveContext()
    }

    func getLastBooking(for user: UserEntity) -> BookingEntity? {
        let request: NSFetchRequest<BookingEntity> = BookingEntity.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)
        request.sortDescriptors = [NSSortDescriptor(key: "bookSession", ascending: false)]
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
}
