//
//  CatsDescriptionViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct Setting: Identifiable {
	var name: String
	var value: CatsDescriptionValue
	
	var id = UUID()
	
	init(_ name: String, _ value: CatsDescriptionValue) {
		self.name = name
		self.value = value
	}
}

final class CatsDescriptionViewModel: ObservableObject {
	
	var cat: CatsCard
	
	@Published var category: CatsDescriptionCategory = .physical
	
	var currentSettings: [Setting] {
		determineSettings(for: self.category)
	}
	
	var friendlyCharacteristics: [(String, Int)] {
		let settings = determineSettings(for: .psycological)
		var characteristics: [(String, Int)] = []
		
		for setting in settings {
			switch setting.value {
				case let .int(value):
					characteristics.append((setting.name, Int(value)))
				default:
					continue
			}
		}
		return characteristics
	}
	
	init(cat: CatsCard) {
		self.cat = cat
	}
}

// MARK: - Public methods
extension CatsDescriptionViewModel {
	
	func settingsFor(category: CatsDescriptionCategory) -> [Setting] {
		determineSettings(for: category)
	}
	
	func reorderDataNames(names: [String]) -> [String] {
		var index = 0
		let first = names[index]
		var result = [String](repeating: "", count: names.count)
		
		while index != (names.count - 1) {
			index += 1
			let nextName = names[index]
			result[index] = first
			result[index - 1] = nextName
		}
		
		return result
	}
}
	
// MARK:- Private methods
extension CatsDescriptionViewModel {
	
	private func determineSettings(for category: CatsDescriptionCategory) -> [Setting] {
		switch category {
			case .physical:
				return
					[
						Setting("Suppressed tail", .bool(cat.suppressedTail)),
						Setting("Short legs", .bool(cat.shortLegs)),
						Setting("Hairless", .bool(cat.hairless)),
						Setting("Weight", .float(cat.weight)),
						Setting("Castrated", .bool(cat.isCastrated))
					]
				
			case .psycological:
				return
					[
						Setting("Stranger friendly", .int(cat.strangerFriendly)),
						Setting("Child friendly", .int(cat.childFriendly)),
						Setting("Dog friendly", .int(cat.dogFriendly)),
						Setting("Temperament", .temperament(cat.wrappedTemperament)),
					]
				
			case .shows:
				return
					[
						Setting("Cat shows", .showsArray(cat.wrappedCatShows)),
					]
				
		}
	}
}
