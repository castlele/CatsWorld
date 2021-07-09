//
//  CatsDescriptionViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI
import CoreData

final class CatsDescriptionViewModel: CatManipulator {
	
	private var cat: CatsCard!
	private var context: NSManagedObjectContext
	
	var editingCatsPageView: EditingCatsPageView!
	
	@Published var ageType: AgeType = .age
	@Published var isEditingCatsPage = false
	
	var catsCardColor: Color { cat.wrappedColor }
	
	var additionInfo: String { cat.wrappedInfo }
	
	var isAdditionInfo: Bool { !additionInfo.isEmpty }
	
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
	
	init(cat: CatsCard, context: NSManagedObjectContext) {
		self.context = context
		selectCat(cat)
	}
}

// MARK: - Public methods
extension CatsDescriptionViewModel {
	
	func changeAgeType() {
		switch ageType {
			case .age:
				ageType = .dateOfBirth
			case .dateOfBirth:
				ageType = .age
		}
	}
	
	func editCat() {
		let catsViewModel = CatsCardsPageViewModel(cat: getCat(), deleteAfterCancelation: false, managedObjectContext: context)
		editingCatsPageView = EditingCatsPageView(catsViewModel: catsViewModel)
		
		isEditingCatsPage.toggle()
	}
	
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
	
	func getCat() -> CatsCard { cat }
	
	func selectCat(_ cat: CatsCard) { self.cat = cat }
	
	func deselectCat() { self.cat = nil }
}
