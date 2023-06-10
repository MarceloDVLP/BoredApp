//
//  ActivityEntity+CoreDataProperties.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 10/06/23.
//
//

import Foundation
import CoreData


extension ActivityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityEntity> {
        return NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
    }

    @NSManaged public var activity: String
    @NSManaged public var accessibility: Double
    @NSManaged public var type: String
    @NSManaged public var participants: Int32
    @NSManaged public var price: Double
    @NSManaged public var key: String
    @NSManaged public var dateStart: Date
}

extension ActivityEntity : Identifiable {

}
