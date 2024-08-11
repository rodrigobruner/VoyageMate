//
//  Cost+CoreDataProperties.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//
//

import Foundation
import CoreData


extension Cost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cost> {
        return NSFetchRequest<Cost>(entityName: "Cost")
    }

    @NSManaged public var costID: UUID?
    @NSManaged public var name: String?
    @NSManaged public var value: Double
    @NSManaged public var date: Date?
    @NSManaged public var relationship: Trip?

}

extension Cost : Identifiable {

}
