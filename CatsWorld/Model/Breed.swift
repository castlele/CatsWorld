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
	
	var adaptability: Int
	var affectionLevel: Int
	var childFriendly: Int
	var countryCode: String
	var countryCodes: String
	var description: String
	var dogFriendly: Int
	var energyLevel: Int
	var experimental: Int
	var grooming: Int
	var hairless: Int
	var healthIssues: Int
	var hypoAllergenic: Int
	var id: String
	var indoor: Int
	var intelligence: Int
	var lifeSpan: String
	var name: String
	var natural: Int
	var origin: String
	var rare: Int
	var rex: Int
	var sheddingLevel: Int
	var shortLegs: Int
	var socialNeeds: Int
	var strangerFriendly: Int
	var suppressedTail: Int
	var temperament: String
	var vocalisation: Int
	var weight: Weight

	enum CodingKeys: String, CodingKey {
		case adaptability
		case affectionLevel = "affection_level"
		case childFriendly = "child_friendly"
		case countryCode = "country_code"
		case countryCodes = "country_codes"
		case description
		case dogFriendly = "dog_friendly"
		case energyLevel = "energy_level"
		case experimental
		case grooming
		case hairless
		case healthIssues = "health_issues"
		case hypoAllergenic = "hypoallergenic"
		case id
		case indoor
		case intelligence
		case lifeSpan = "life_span"
		case name
		case natural
		case origin
		case rare
		case rex
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
