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
		id: "0", name: "Name", adaptability: 0, affectionLevel: 0, childFriendly: 0, dogFriendly: 0, indoor: 0, intelligence: 0, strangerFriendly: 0, temperament: "Melan", energyLevel: 0, grooming: 0, hairless: 0, healthIssues: 0, hypoAllergenic: 0, lifeSpan: "", sheddingLevel: 0, shortLegs: 0, suppressedTail: 0, vocalisation: 0, weight: Weight(imperial: "", metric: ""), natural: 0, description: "", origin: "", rare: 0, socialNeeds: 0
	)
}

