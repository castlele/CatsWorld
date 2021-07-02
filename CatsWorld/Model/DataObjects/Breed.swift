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
						Description("Temperament", .str(self.temperament)),
						Description("Adaptability", .int(Int16(self.adaptability))),
						Description("Affection Level", .int(Int16(self.affectionLevel))),
						Description("Stranger Friendly", .int(Int16(self.strangerFriendly))),
						Description("Child Friendly", .int(Int16(self.childFriendly))),
						Description("Dog Friendly", .int(Int16(self.dogFriendly))),
						Description("Social Needs", .int(Int16(self.socialNeeds))),
						Description("Intelligence", .int(Int16(self.intelligence)))
					]
				
			case .physical:
				return
					[
						Description("Standard Weight", .str(self.weight.imperial)),
						Description("Standard Metrics", .str(self.weight.metric)),
						Description("Health Issues", .int(Int16(self.healthIssues))),
						Description("Energy Level", .int(Int16(self.energyLevel))),
						Description("Grooming", .int(Int16(self.grooming))),
						Description("Shedding Level", .int(Int16(self.sheddingLevel))),
						Description("Hairless", .bool(self.hairless == 1 ? true : false)),
						Description("Hypoallergic", .bool(self.hypoAllergenic == 1 ? true : false)),
						Description("Life Span", .str(self.lifeSpan)),
						Description("Short legs", .bool(self.shortLegs == 1 ? true : false)),
						Description("Suppressed Tail", .bool(self.suppressedTail == 1 ? true : false)),
						Description("Vocalisation", .bool(self.vocalisation == 1 ? true : false))
					]
				
			case .other:
				return
					[
						Description("Natural", .bool(self.natural == 1 ? true : false)),
						Description("Rare", .bool(self.rare == 1 ? true : false)),
						Description("Origin", .str(self.origin)),
						Description("Description", .str(self.description))
					]
				
			default:
				return []
		}
	}
}
