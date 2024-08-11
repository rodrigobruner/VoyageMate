//
//  Trip+CoreDataProperties.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var tripID: UUID?
    @NSManaged public var name: String?
    @NSManaged public var destination: String?
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var notes: String?
    @NSManaged public var relationship: Cost?

}

extension Trip : Identifiable {

}
