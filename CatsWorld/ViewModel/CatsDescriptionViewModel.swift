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
		let settings = determineDescriptions(for: .psycological)
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

// MARK: - Describing protocol comformance
extension CatsDescriptionViewModel: Describable {
	
	func getDescriptionsFor(category: CatsDescriptionCategory) -> [Description] {
		determineDescriptions(for: category)
	}
	
	/// Determines Settings with values for certain cat and certain category
	/// - Parameter category: Category of "settigns" for cat
	/// - Returns: Array of `Setting`s with name and value
	private func determineDescriptions(for category: CatsDescriptionCategory) -> [Description] {
		switch category {
			case .physical:
				return
					[
						Description("Suppressed tail".localize(), .bool(cat.suppressedTail)),
						Description("Short legs".localize(), .bool(cat.shortLegs)),
						Description("Hairless".localize(), .bool(cat.hairless)),
						Description("Weight".localize(), .float(cat.weight)),
						Description("Castrated".localize(), .bool(cat.isCastrated))
					]
				
			case .psycological:
				return
					[
						Description("Stranger friendly".localize(), .int(cat.strangerFriendly)),
						Description("Child friendly".localize(), .int(cat.childFriendly)),
						Description("Dog friendly".localize(), .int(cat.dogFriendly)),
						Description("Temperament".localize(), .temperament(cat.wrappedTemperament)),
					]
				
			case .shows:
				return
					[
						Description("Cat shows".localize(), .showsArray(cat.wrappedCatShows)),
					]
				
			default:
				return
					[
						
					]
		}
	}
}

// MARK: - Public methods
extension CatsDescriptionViewModel {
	
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
