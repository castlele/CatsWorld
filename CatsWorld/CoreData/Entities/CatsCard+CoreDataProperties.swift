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
import SwiftUI


extension CatsCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatsCard> {
        return NSFetchRequest<CatsCard>(entityName: "CatsCard")
    }

	// Properties needed for the card
	@NSManaged public var image: Data?
	@NSManaged public var color: Data?
	
	// General cat properties
    @NSManaged public var name: String?
    @NSManaged public var breed: String?
	@NSManaged public var sex: String?
    @NSManaged public var dateOfBirth: Date?
	
	// Physical cat properties
	@NSManaged public var suppressedTail: Bool
	@NSManaged public var shortLegs: Bool
	@NSManaged public var hairless: Bool
	@NSManaged public var weight: Float
	@NSManaged public var isCastrated: Bool
	
	// Psycological cat properties
	@NSManaged public var strangerFriendly: Int16
	@NSManaged public var childFriendly: Int16
	@NSManaged public var dogFriendly: Int16
	@NSManaged public var temperament: Data?
	
	// Cat's shows properties
	@NSManaged public var catShows: Data?
	
	// Additional information string
	@NSManaged public var additionalInfo: String?
}

// MARK:- Wrapped properties
extension CatsCard : Identifiable {
	
	public var id: UUID {
		UUID()
	}
	
	var wrappedName: String {
		name ?? "None".localize()
	}
	
	var wrappedBreed: String {
		breed ?? "None".localize()
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
	
	var wrappedDateOfBirth: String {
		guard let dateOfBirth = dateOfBirth else {
			return "None".localize()
		}
		let format = "d MMM YYYY"
		
		return dateOfBirth.getFormattedDate(format: format)
	}

	var wrappedColor: UIColor {
		UIColor.color(withData: color)
	}
	
	var genderColor: Color {
		switch wrappedSex {
			case "male":
				return Color(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1))
			default:
				return Color(#colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1))
		}
	}
	
	var wrappedSex: String {
		switch sex {
			case "male":
				return "male"
			default:
				return "female"
		}
	}
	
	var genderSign: String {
		switch wrappedSex {
			case "male":
				return "♂"
			default:
				return "♀"
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

// MARK:- Public functions
extension CatsCard {
	
	/// Converts `Color` to data and assigns it to `self.color` property
	/// - Parameter color: `SwiftUI` `Color` instance
	func setColor(_ color: Color) {
		let uiColor = UIColor(color)
		let data = uiColor.encode()
		
		self.color = data
	}
}

// MARK:- Private helper functions
extension CatsCard {
	
	/// Pick needed age and its measurement
	/// - Parameter dc: Date components of age
	/// - Returns: Age as `String`
	private func getAge(dateComponents dc: DateComponents) -> String {
		if let year = dc.year, dc.year != 0 {
			return makeStringAge(year, measurement: "Year")
			
		} else if let month = dc.month, dc.month != 0 {
			return makeStringAge(month, measurement: "Month")
			
		} else if let week = dc.weekday, dc.weekday != 0 {
			return makeStringAge(week, measurement: "Week")
			
		} else if let day = dc.day, dc.day != 0 {
			return makeStringAge(day, measurement: "Day")
			
		} else {
			return "None"
		}
	}
	
	/// Makes age as string
	/// - Parameter age: Age as `Int`
	/// - Parameter measurement: In what age measures
	/// - Returns: Age as`String`
	private func makeStringAge(_ age: Int, measurement: String) -> String {
		let key = measurement + " count"
		
		return key.localize(arguments: age)
	}
}

// MARK: - Describable protocol conformance
extension CatsCard: Describable {
	
	func getDescriptionsFor(category: CatsDescriptionCategory) -> [Description] {
		determineDescriptions(for: category)
	}
	
	/// Determines Settings with values for certain cat and certain category
	/// - Parameter category: Category of "settigns" for cat
	/// - Returns: Array of `Setting`s with name and value
	private func determineDescriptions(for category: CatsDescriptionCategory) -> [Description] {
		switch category {
			case .physical:
				return
					[
						Description("Suppressed tail".localize(), .bool(self.suppressedTail)),
						Description("Short legs".localize(), .bool(self.shortLegs)),
						Description("Hairless".localize(), .bool(self.hairless)),
						Description("Weight".localize(), .float(self.weight)),
						Description("Castrated".localize(), .bool(self.isCastrated))
					]
				
			case .psycological:
				return
					[
						Description("Stranger friendly".localize(), .int(self.strangerFriendly)),
						Description("Child friendly".localize(), .int(self.childFriendly)),
						Description("Dog friendly".localize(), .int(self.dogFriendly)),
						Description("Temperament".localize(), .temperament(self.wrappedTemperament)),
					]
				
			case .shows:
				return
					[
						Description("Cat shows".localize(), .showsArray(self.wrappedCatShows)),
					]
				
			default:
				return
					[
						
					]
		}
	}
}
