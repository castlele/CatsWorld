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

	// Properties needed for the card
    @NSManaged public var id: UUID?
	@NSManaged public var image: Data?
	@NSManaged public var color: Data?
	
	// General cat properties
    @NSManaged public var name: String?
    @NSManaged public var breed: String?
	@NSManaged public var sex: String?
    @NSManaged public var dateOfBirth: Date?
	
	// Physical cat properties
	@NSManaged public var isPhysicalSectionEnabled: Bool
	@NSManaged public var suppressedTail: Bool
	@NSManaged public var shortLegs: Bool
	@NSManaged public var hairless: Bool
	@NSManaged public var weight: Float
	@NSManaged public var isCastrated: Bool
	
	// Psycological cat properties
	@NSManaged public var isPsycolocicalSectionEnabled: Bool
	@NSManaged public var strangerFriendly: Int16
	@NSManaged public var childFriendly: Int16
	@NSManaged public var dogFriendly: Int16
	@NSManaged public var temperament: Data?
	
	// Cat's shows properties
	@NSManaged public var isCatShowsSectionEnabled: Bool
	@NSManaged public var catShows: Data?
	
	// Additional information string
	@NSManaged public var additionalInfo: String?
}

// MARK:- Wrapped properties
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
		// Default UIImage
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
			case "male":
				return "male"
			default:
				return "female"
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
	
	var wrappedTemperament: Temperament {
		let defaultValue = Temperament.choleric
		
		if let data = temperament {
			do {
				return try JSONParser.parse(from: data)
			} catch {
				return defaultValue
			}
		}
		return defaultValue
	}
}

// MARK:- Private helper functions
extension CatsCard {
	
	/// Pick needed age and its measurement
	/// - Parameter dc: Date components of age
	/// - Returns: Age as `String`
	private func getAge(dateComponents dc: DateComponents) -> String {
		if let year = dc.year, dc.year != 0 {
			return makeStringAge(year, measurement: "year")
			
		} else if let month = dc.month, dc.month != 0 {
			return makeStringAge(month, measurement: "month")
			
		} else if let week = dc.weekday, dc.weekday != 0 {
			return makeStringAge(week, measurement: "week")
			
		} else if let day = dc.day, dc.day != 0 {
			return makeStringAge(day, measurement: "day")
			
		} else {
			return "None"
		}
	}
	
	/// Makes age as string
	/// - Parameter age: Age as `Int`
	/// - Parameter measurement: In what age measures
	/// - Returns: Age as`String`
	private func makeStringAge(_ age: Int, measurement: String) -> String {
		if age == 1 {
			return "\(age) \(measurement)"
		}
		return "\(age) \(measurement)s"
	}
}
