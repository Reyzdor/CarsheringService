//
//  BookingEntity+CoreDataProperties.swift
//  CarsheringService
//
//  Created by Roman on 27.10.2025.
//
//

public import Foundation
public import CoreData


public typealias BookingEntityCoreDataPropertiesSet = NSSet

extension BookingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookingEntity> {
        return NSFetchRequest<BookingEntity>(entityName: "BookingEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var status: Bool
    @NSManaged public var book_session: Date?
    @NSManaged public var user: UserEntity?

}

extension BookingEntity : Identifiable {

}
