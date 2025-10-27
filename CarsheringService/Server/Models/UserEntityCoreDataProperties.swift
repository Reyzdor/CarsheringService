import Foundation
import CoreData

extension UserEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var phone: String
    @NSManaged public var password: String
    @NSManaged public var regDate: Date

    @NSManaged public var bookings: NSSet?
}

extension UserEntity {
    @objc(addBookingsObject:)
    @NSManaged public func addToBookings(_ value: BookingEntity)

    @objc(removeBookingsObject:)
    @NSManaged public func removeFromBookings(_ value: BookingEntity)
}
