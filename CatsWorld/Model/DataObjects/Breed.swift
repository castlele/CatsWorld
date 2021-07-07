//
//  Breed.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import Foundation

extension Breed: Equatable {
	static func == (lhs: Breed, rhs: Breed) -> Bool {
		lhs.id == rhs.id || lhs.name == rhs.name
	}
}

struct Breed: Codable, Identifiable {
	
	var id: String
	
	var name: String
	
	var adaptability: Int
	var affectionLevel: Int
	var strangerFriendly: Int
	var childFriendly: Int
	var dogFriendly: Int
	var socialNeeds: Int
	var intelligence: Int
	var temperament: String
	
	var energyLevel: Int
	var grooming: Int
	var hairless: Int
	var healthIssues: Int
	var hypoAllergenic: Int
	var lifeSpan: String
	var sheddingLevel: Int
	var shortLegs: Int
	var suppressedTail: Int
	var vocalisation: Int
	var weight: Weight
	
	var natural: Int
	var description: String
	var origin: String
	var rare: Int
	

	enum CodingKeys: String, CodingKey {
		case adaptability
		case affectionLevel = "affection_level"
		case childFriendly = "child_friendly"
		case description
		case dogFriendly = "dog_friendly"
		case energyLevel = "energy_level"
		case grooming
		case hairless
		case healthIssues = "health_issues"
		case hypoAllergenic = "hypoallergenic"
		case id
		case intelligence
		case lifeSpan = "life_span"
		case name
		case natural
		case origin
		case rare
		case sheddingLevel = "shedding_level"
		case shortLegs = "short_legs"
		case socialNeeds = "social_needs"
		case strangerFriendly = "stranger_friendly"
		case suppressedTail = "suppressed_tail"
		case temperament
		case vocalisation
		case weight
	}
}

struct Weight: Codable {
	var imperial: String
	var metric: String
}

// MARK: - Describable protocol comformance
extension Breed: Describable {
	
	func getDescriptionsFor(category: CatsDescriptionCategory) -> [Description] {
		determineDescriptions(for: category)
	}
	
	/// Determines Settings with values for certain cat and certain category
	/// - Parameter category: Category of "settigns" for cat
	/// - Returns: Array of `Setting`s with name and value
	private func determineDescriptions(for category: CatsDescriptionCategory) -> [Description] {
		switch category {
			case .psycological:
				return
					[
						Description("Temperament".localize(), .str(makeTemperament(self.temperament))),
						Description("Adaptability".localize(), .int(Int16(self.adaptability))),
						Description("Affection Level".localize(), .int(Int16(self.affectionLevel))),
						Description("Stranger Friendly".localize(), .int(Int16(self.strangerFriendly))),
						Description("Child Friendly".localize(), .int(Int16(self.childFriendly))),
						Description("Dog Friendly".localize(), .int(Int16(self.dogFriendly))),
						Description("Social Needs".localize(), .int(Int16(self.socialNeeds))),
						Description("Intelligence".localize(), .int(Int16(self.intelligence)))
					]
				
			case .physical:
				return
					[
						Description("Standard Weight".localize(), .str(self.weight.imperial)),
						Description("Standard Metrics".localize(), .str(self.weight.metric)),
						Description("Health Issues".localize(), .int(Int16(self.healthIssues))),
						Description("Energy Level".localize(), .int(Int16(self.energyLevel))),
						Description("Grooming".localize(), .int(Int16(self.grooming))),
						Description("Shedding Level".localize(), .int(Int16(self.sheddingLevel))),
						Description("Hairless".localize(), .bool(self.hairless == 1 ? true : false)),
						Description("Hypoallergenic".localize(), .bool(self.hypoAllergenic == 1 ? true : false)),
						Description("Life Span".localize(), .str(self.lifeSpan)),
						Description("Short legs".localize(), .bool(self.shortLegs == 1 ? true : false)),
						Description("Suppressed Tail".localize(), .bool(self.suppressedTail == 1 ? true : false)),
						Description("Vocalization".localize(), .bool(self.vocalisation == 1 ? true : false))
					]
				
			case .other:
				return
					[
						Description("Natural".localize(), .bool(self.natural == 1 ? true : false)),
						Description("Rare".localize(), .bool(self.rare == 1 ? true : false)),
						Description("Origin".localize(), .str(self.origin.localize())),
						Description("Description".localize(), .str("\(self.name) disc".localize()))
					]
				
			default:
				return []
		}
	}
	
	private func makeTemperament(_ originalStr: String) -> String {
		let localizedArray = originalStr
			.split(separator: ",")
			.map { String($0).trimmingCharacters(in: .whitespacesAndNewlines).lowercased().localize() }
		
		return localizedArray.joined(separator: ", ")
	}
}
