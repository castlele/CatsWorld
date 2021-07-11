//
//  EndPointTests.swift
//  CatsWorldTests
//
//  Created by Nikita Semenov on 11.05.2021.
//

import XCTest
@testable import CatsWorld

class EndPointTests: XCTestCase {
	
	var endPoint: EndPoint!

    override func setUpWithError() throws {
		
    }

    override func tearDownWithError() throws {
        endPoint = nil
    }

    func testBreedsURLMakerWithQuery() throws {
		endPoint = EndPoint.breedsAPI([(.attachBreed, "0")])
		let url = endPoint.url
		
		let expectedStringURL = "https://api.thecatapi.com/v1/breeds?attach_breed=0"
		let expectedURL = URL(string: expectedStringURL)
		
		XCTAssertEqual(url, expectedURL)
    }
	
	func testBreedsURLMaker() throws {
		endPoint = EndPoint.breedsAPI([])
		let url = endPoint.url
		
		let expectedStringURL = "https://api.thecatapi.com/v1/breeds"
		let expectedURL = URL(string: expectedStringURL)
		
		XCTAssertEqual(url, expectedURL)
	}

	func testCatsImageEndPoint() throws {
		endPoint = EndPoint.imagesAPI([(.breedID, "curl")])
		
		let url = endPoint.url
		let expectedURL = URL(string: "https://api.thecatapi.com/v1/images/search?breed_ids=curl")
		
		XCTAssertEqual(expectedURL!, url!)
	}
}
