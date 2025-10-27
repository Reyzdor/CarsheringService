import Foundation
import CoreData

extension CarEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarEntity> {
        return NSFetchRequest<CarEntity>(entityName: "CarEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var brand: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var fuelLevel: Double
    @NSManaged public var isBooked: Bool

    @NSManaged public var bookings: NSSet?
}
