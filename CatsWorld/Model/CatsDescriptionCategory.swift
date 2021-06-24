//
//  CatsDescriptionCategory.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import Foundation

enum CatsDescriptionValue {
	case bool(Bool)
	case int(Int16)
	case float(Float)
	case temperament(Temperament)
	case showsArray([Show])
}

enum CatsDescriptionCategory: String, CaseIterable, Hashable {
	case physical
	case psycological
	case shows
	
	func hash(into hasher: inout Hasher) {
		switch self {
			case .physical:
				hasher.combine("physical")
			case .psycological:
				hasher.combine("psycological")
			case .shows:
				hasher.combine("shows")
		}
	}
}
