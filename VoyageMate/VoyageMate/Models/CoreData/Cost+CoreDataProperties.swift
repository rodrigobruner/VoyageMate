//
//  Cost+CoreDataProperties.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-12.
//
//

import Foundation
import CoreData


extension Cost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cost> {
        return NSFetchRequest<Cost>(entityName: "Cost")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var value: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var trip: Trip?

}

extension Cost : Identifiable {

}
