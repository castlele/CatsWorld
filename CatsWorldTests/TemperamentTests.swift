//
//  Temperament.swift
//  CatsWorldTests
//
//  Created by Nikita Semenov on 18.05.2021.
//

import XCTest
@testable import CatsWorld

class TemperamentTests: XCTestCase {
	
	var temperament: Temperament!

    override func setUpWithError() throws {
		temperament = .choleric
    }

    override func tearDownWithError() throws {
        temperament = nil
    }

    func testInitFromDecoder() throws {
		let data = try! JSONEncoder().encode(temperament)
		let decoder = JSONDecoder()
		
		let decodedObj = try! decoder.decode(Temperament.self, from: data)
		
		XCTAssertEqual(Temperament.choleric, decodedObj)
    }

	func testEncoder() throws {
		let encoder = JSONEncoder()
		
		XCTAssertNoThrow(try? encoder.encode(temperament))
	}

	func testEncoderResult() throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		
		let expectedResult = "{\n  \"rawValue\" : \"choleric\"\n}"
		let data = try! encoder.encode(temperament)
		
		XCTAssertEqual(expectedResult, String(data: data, encoding: .utf8))
	}
}
