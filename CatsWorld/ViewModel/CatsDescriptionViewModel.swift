//
//  CatsDescriptionViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct Description: Identifiable {
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
	@Published var ageType: AgeType = .age
	@Published var isEditingCatsPage = false
	
	var catsCardColor: UIColor { cat.wrappedColor }
	
	/// Represents friendliness of the cat
	/// `categoryName` represents, to whome the cat friendly to
	/// `value` represents how much friendly the cat is
	/// O(n) where n is amount of settings in category
	var friendlyCharacteristics: [(categoryName: String, value: Int)] {
		let settings = cat.getDescriptionsFor(category: .psycological)
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
	
	func getDescriptionsFor(category: CatsDescriptionCategory) -> [Description] {
		cat.getDescriptionsFor(category: category)
	}
	
	/// Reorder names of data for usage in charts
	/// - Parameter names: Names of values
	/// - Returns: Reordered array of names
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
