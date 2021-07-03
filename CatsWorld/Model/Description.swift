//
//  Description.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 03.07.2021.
//

import Foundation

struct Description: Identifiable {
	var name: String
	var value: CatsDescriptionValue
	
	var id = UUID()
	
	init(_ name: String, _ value: CatsDescriptionValue) {
		self.name = name
		self.value = value
	}
}
