//
//  Student+CoreDataProperties.swift
//  DataCustom
//
//  Created by MacStudent on 2020-01-15.
//  Copyright © 2020 MacStudent. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var tution: Double
    @NSManaged public var age: Int32
    @NSManaged public var startDate: Date?

}
