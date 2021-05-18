//
//  JSONParser.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import Foundation

/// Factory class for parsing JSON data
final class JSONParser {
	
	/// Parse JSON from `Data`
	/// - Parameters:
	///   - data: Data from which JSON will be parsed
	///   - completion: Action, that will be done after parsing
	/// - Throws: Standard `JSONDecoder.decode(_:from:)` errors
	static func parse<T: Decodable>(from data: Data, completion: @escaping ([T]) -> Void) throws {
		let decoder = JSONDecoder()
		let decodedJSON = try decoder.decode([T].self, from: data)
		completion(decodedJSON)
	}
	
	/// Parse JSON from `Data` and return array of objects, which were parsed
	/// - Parameter data: Data from which JSON will be parsed
	/// - Throws: Standard `JSONDecoder.decode(_:from:)` errors
	/// - Returns: `Array` of objects which were parsed
	static func parse<T: Decodable>(from data: Data) throws -> [T] {
		let decoder = JSONDecoder()
		let decodedJSON = try decoder.decode([T].self, from: data)
		return decodedJSON
	}
}
