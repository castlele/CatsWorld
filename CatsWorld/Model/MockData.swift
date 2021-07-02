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
		id: "", name: "Name", adaptability: 1, affectionLevel: 2, strangerFriendly: 3, childFriendly: 4, dogFriendly: 5, socialNeeds: 4, intelligence: 3, temperament: "Lox", energyLevel: 2, grooming: 1, hairless: 0, healthIssues: 1, hypoAllergenic: 0, lifeSpan: "1-2", sheddingLevel: 0, shortLegs: 1, suppressedTail: 0, vocalisation: 1, weight: Weight(imperial: "", metric: ""), natural: 0, description: "", origin: "", rare: 1
	)
}

