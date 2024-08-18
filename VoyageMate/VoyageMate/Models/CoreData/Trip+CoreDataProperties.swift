//
//  Trip+CoreDataProperties.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-12.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var destination: String?
    @NSManaged public var end: Date?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var start: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var costs: NSSet?
}

// MARK: Generated accessors for costs
extension Trip {

    @objc(addCostsObject:)
    @NSManaged public func addToCosts(_ value: Cost)

    @objc(removeCostsObject:)
    @NSManaged public func removeFromCosts(_ value: Cost)

    @objc(addCosts:)
    @NSManaged public func addToCosts(_ values: NSSet)

    @objc(removeCosts:)
    @NSManaged public func removeFromCosts(_ values: NSSet)

}

extension Trip : Identifiable {

}
