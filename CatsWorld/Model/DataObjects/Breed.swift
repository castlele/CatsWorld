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
	var childFriendly: Int
	var dogFriendly: Int
	var indoor: Int
	var intelligence: Int
	var strangerFriendly: Int
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
	var socialNeeds: Int
	

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
		case indoor
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
