//
//  CatsCard+CoreDataProperties.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//
//

import Foundation
import CoreData


extension CatsCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatsCard> {
        return NSFetchRequest<CatsCard>(entityName: "CatsCard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var breed: String?
    @NSManaged public var age: Int16
    @NSManaged public var image: Data?

}

extension CatsCard : Identifiable {

}
