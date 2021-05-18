//
//  CatsCard+CoreDataProperties.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//
//

import Foundation
import CoreData
import UIKit


extension CatsCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatsCard> {
        return NSFetchRequest<CatsCard>(entityName: "CatsCard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var breed: String?
	@NSManaged public var sex: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var image: Data?
	@NSManaged public var color: Data?
	@NSManaged public var suppressedTail: Bool
	@NSManaged public var shorthaired: Bool
	@NSManaged public var shortLegs: Bool
	@NSManaged public var hairless: Bool
	@NSManaged public var strangerFriendly: Int16
	@NSManaged public var childFriendly: Int16
	@NSManaged public var dogFriendly: Int16
	@NSManaged public var weight: Float
	@NSManaged public var isCastrated: Bool
	@NSManaged public var additionalInfo: String?
	@NSManaged public var catShows: Data?
}

extension CatsCard : Identifiable {
	
	var wrappedName: String {
		name ?? "None"
	}
	
	var wrappedBreed: String {
		breed ?? "None"
	}
	
	var wrappedImage: UIImage {
		if let imageData = image {
			if let uiImage = UIImage(data: imageData) {
				return uiImage
			}
		}
		return UIImage(systemName: "person.crop.circle.fill")!
	}
	
	var age: String {
		let now = Date()
		let calendar = Calendar.current
		let ageComponents = calendar.dateComponents([.year, .month, .weekday, .day], from: dateOfBirth ?? Date(), to: now)
		let age = getAge(dateComponents: ageComponents)
		
		return age
	}

	var wrappedColor: UIColor {
		UIColor.color(withData: color)
	}
	
	var wrappedSex: String {
		switch sex {
			case "M":
				return "M"
			case "W":
				return "W"
			default:
				return "-"
		}
	}
	
	var wrappedInfo: String {
		additionalInfo ?? ""
	}
	
	var wrappedCatShows: [Show] {
		if let data = catShows {
			do {
				let shows: [Show] = try JSONParser.parse(from: data)
				return shows
			} catch {
				return []
			}
		}
		return []
	}
}

extension CatsCard {
	private func getAge(dateComponents dc: DateComponents) -> String {
		if let year = dc.year, dc.year != 0 {
			return makeStringAge(year)
			
		} else if let month = dc.month, dc.month != 0 {
			return makeStringAge(month)
			
		} else if let week = dc.weekday, dc.weekday != 0 {
			return makeStringAge(week)
			
		} else if let day = dc.day, dc.day != 0 {
			return makeStringAge(day)
			
		} else {
			return "None"
		}
	}
	
	private func makeStringAge(_ age: Int) -> String {
		if age == 1 {
			return "\(age) year"
		}
		return "\(age) years"
	}
}
