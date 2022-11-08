//
//  Artist+CoreDataProperties.swift
//  19m
//
//  Created by Matilda Davydov on 07.11.2022.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var country: String?
    @NSManaged public var birth: String?
    @NSManaged public var occupation: String?
    @NSManaged public var lastname: String?
    @NSManaged public var name: String?

}

extension Artist : Identifiable {

}
