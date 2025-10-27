import Foundation
import CoreData

extension BookingEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookingEntity> {
        return NSFetchRequest<BookingEntity>(entityName: "BookingEntity")
    }

    @NSManaged public var bookSession: Date
    @NSManaged public var user: UserEntity?
    @NSManaged public var car: CarEntity?
}
