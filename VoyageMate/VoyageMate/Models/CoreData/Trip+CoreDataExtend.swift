//
//  Trip+CoreDataExtend.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-12.
//

import Foundation

extension Trip{
    //Get costs as Array
    public var costsArray: [Cost] {
        let costsSet = costs as? Set<Cost> ?? []
        return Array(costsSet)
    }
}
