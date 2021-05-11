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
		endPoint = EndPoint.breedsAPI([.attachBreed])
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
}
