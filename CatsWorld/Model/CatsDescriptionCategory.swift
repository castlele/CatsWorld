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
	case str(String)
	case float(Float)
	case temperament(Temperament)
	case showsArray([Show])
}

enum CatsDescriptionCategory: String, CaseIterable {
	case physical
	case psycological
	case shows
	case other
}
