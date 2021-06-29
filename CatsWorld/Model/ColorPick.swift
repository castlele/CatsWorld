//
//  ColorPick.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 29.06.2021.
//

import Foundation

enum ColorPick: String, CaseIterable, Identifiable {
	case none = "mainColor"
	case banana = "Banana"
	case cantaloupe = "Cantaloupe"
	case flora = "Flora"
	case ice = "Ice"
	case lavender = "Lavender"
	case orchid = "Orchid"
	case salmon = "Salmon"
	
	var id: UUID { UUID() }
	
	static var firstHalf: [ColorPick] = [.none, .banana, .cantaloupe, .flora]
	static var secondHalf: [ColorPick] = [.ice, .lavender, .orchid, .salmon]
}
