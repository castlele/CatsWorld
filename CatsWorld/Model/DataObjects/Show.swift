//
//  Show.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import Foundation

/// Representation of cats' shows
struct Show: Codable, Identifiable, Hashable {
	var name: String
	var place: Int
	
	var id: UUID {
		UUID()
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(name)
	}
}
