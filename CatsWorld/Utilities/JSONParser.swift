//
//  JSONParser.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import Foundation

/// Factory class for parsing JSON data
final class JSONParser {
	
	static var shared = JSONParser()
	
	init() {}
}

// MARK:- Public methods
extension JSONParser {
	
	/// Parse JSON from `Data`
	/// - Parameters:
	///   - data: Data from which JSON will be parsed
	///   - completion: Action, that will be done after parsing
	func parse<T: Decodable>(from data: Data, completion: @escaping (Result<[T], CWError>) -> Void)  {
		let decoder = JSONDecoder()
		
		do {
			let decodedJSON = try decoder.decode([T].self, from: data)
			completion(.success(decodedJSON))
		} catch {
			completion(.failure(.decodeError))
		}
	}
	
	func parseWithSerialization(from data: Data, argument: String, completion: @escaping (Result<Any, CWError>) -> Void) {
		do {
			guard let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
				completion(.failure(.decodeError))
				return
			}
			guard let result = json[0][argument] else {
				completion(.failure(.decodeError))
				return
			}
			
			completion(.success(result))
			
		} catch {
			print("\(error.localizedDescription)")
			completion(.failure(.decodeError))
		}
	}
	
	/// Parse JSON from `Data` and return array of objects, which were parsed
	/// - Parameter data: Data from which JSON will be parsed
	/// - Throws: Standard `JSONDecoder.decode(_:from:)` errors
	/// - Returns: `Array` of objects which were parsed
	func parse<T: Decodable>(from data: Data) throws -> T {
		let decoder = JSONDecoder()
		let decodedJSON = try decoder.decode(T.self, from: data)
		return decodedJSON
	}
	
	/// Encode `Encodable` object into data
	/// - Parameter obj: `Encodable` object to encode
	/// - Throws: Standard `JSONEncoder.encode(_:)` errors
	/// - Returns: Encoded object as `Data`
	func encode<T: Encodable>(_ obj: T) throws -> Data {
		let encoder = JSONEncoder()
		let data = try encoder.encode(obj)
		return data
	}
}
