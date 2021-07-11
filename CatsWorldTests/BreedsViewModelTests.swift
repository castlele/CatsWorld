//
//  BreedsViewModelTests.swift
//  CatsWorldTests
//
//  Created by Nikita Semenov on 10.07.2021.
//

import XCTest
@testable import CatsWorld

class BreedsViewModelTests: XCTestCase {
	
	let breedsViewModel = BreedsViewModel()

    override func setUpWithError() throws {
		breedsViewModel.loadBreeds()
    }

    override func tearDownWithError() throws {
        
    }

    func testImageLoading() throws {
		let sampleBreed = Breed(id: "char", name: "", adaptability: 0, affectionLevel: 0, strangerFriendly: 0, childFriendly: 0, dogFriendly: 0, socialNeeds: 0, intelligence: 0, temperament: "", energyLevel: 0, grooming: 0, hairless: 0, healthIssues: 0, hypoAllergenic: 0, lifeSpan: "", sheddingLevel: 0, shortLegs: 0, suppressedTail: 0, vocalisation: 0, weight: Weight(imperial: "", metric: ""), natural: 0, description: "", origin: "", rare: 0)
		breedsViewModel.loadImage(forBreed: sampleBreed)
		
		XCTAssertNotNil(breedsViewModel.wrappedImage)
    }
}
