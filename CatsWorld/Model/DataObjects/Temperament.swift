//
//  Temperament.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import Foundation

/// Representation of cat's Temperament
enum Temperament: String, CaseIterable {
	case choleric
	case melancholic
	case phlegmatic
	case sanguine
}

// MARK:- Codable protocol confirmation
extension Temperament: Codable {
	
	/// Key for Encoding and Decoding
	enum Key: CodingKey {
		case rawValue
	}
	
	enum CodingError: Error {
		case unknownValue
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Key.self)
		let rawValue = try container.decode(String.self, forKey: .rawValue)
		
		switch rawValue {
			case "choleric":
				self = .choleric
			case "melancholic":
				self = .melancholic
			case "phlegmatic":
				self = .phlegmatic
			case "sanguine":
				self = .sanguine
			default:
				throw CodingError.unknownValue
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Key.self)
		
		switch self {
			case .choleric:
				try container.encode("choleric", forKey: .rawValue)
			case .melancholic:
				try container.encode("melancholic", forKey: .rawValue)
			case .phlegmatic:
				try container.encode("phlegmatic", forKey: .rawValue)
			case .sanguine:
				try container.encode("sanguine", forKey: .rawValue)
		}
	}
}
