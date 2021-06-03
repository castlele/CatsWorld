//
//  MockData.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import Foundation

struct MockData {
	
	static let breeds = [sampleBreed, sampleBreed, sampleBreed]
	
	static let sampleBreed = Breed(
		adaptability: 0,
		affectionLevel: 0,
		childFriendly: 0,
		countryCode: "-",
		countryCodes: "-",
		description: "...",
		dogFriendly: 0,
		energyLevel: 0,
		experimental: 0,
		grooming: 0,
		hairless: 0,
		healthIssues: 0,
		hypoAllergenic: 0,
		id: "0",
		indoor: 0,
		intelligence: 0,
		lifeSpan: "",
		name: "UNKNOWN",
		natural: 0,
		origin: "",
		rare: 0,
		rex: 0,
		sheddingLevel: 0,
		shortLegs: 0,
		socialNeeds: 0,
		strangerFriendly: 0,
		suppressedTail: 0,
		temperament: "UNKONWN",
		vocalisation: 0,
		weight: Weight(imperial: "", metric: "")
	)
}

