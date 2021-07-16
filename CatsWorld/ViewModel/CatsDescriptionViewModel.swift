//
//  CatsDescriptionViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI
import CoreData

/// VIew Model of `MainCatsPageView`
final class CatsDescriptionViewModel: CatManipulator {
	
	/// Instance of `CatsCard` which properties should be translated to SwiftUI Views
	private var cat: CatsCard!
	private var context: NSManagedObjectContext
	/// Currently selected color scheme of the app to track shadows' color and `CatsMainInfoView`'s background color
	@Published private var colorScheme: ColorScheme!
	
	var editingCatsPageView: EditingCatsPageView!
	
	/// Format of representing age in `CatsMainInfoView`
	@Published var ageType: AgeType = .age
	/// Represent if `EditingCatsPageView` should be shown
	@Published var isEditingCatsPage = false
	
	var catsCardColor: Color { determineCatsCardsColor() }
	
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
	
	// MARK: - Initialization
	init(cat: CatsCard, context: NSManagedObjectContext) {
		self.context = context
		selectCat(cat)
	}
}

// MARK: - Public methods
extension CatsDescriptionViewModel {
	
	/// Assign new value to private `colorScheme` property
	/// - Parameter colorScheme: New color scheme
	func setColorScheme(_ colorScheme: ColorScheme) {
		self.colorScheme = colorScheme
	}
	
	/// Assign nil to private `colorScheme` property
	func removeColorScheme() {
		self.colorScheme = nil
	}
	
	/// Changes value of property `ageType`
	func changeAgeType() {
		switch ageType {
			case .age:
				ageType = .dateOfBirth
			case .dateOfBirth:
				ageType = .age
		}
	}
	
	/// Set up `EditingCatsPageView` and toggle `isEditingCatsPage`
	func editCat() {
		let catsViewModel = CatsCardsPageViewModel(cat: getCat(), deleteAfterCancelation: false, managedObjectContext: context)
		editingCatsPageView = EditingCatsPageView(catsViewModel: catsViewModel)
		
		isEditingCatsPage.toggle()
	}
	
	/// Get array of descriptions of the cat for certain category
	/// Used to transform `CatsCard`'s properties to SwiftUI Views
	/// - Parameter category: Category, which properties should be transformed to `Description`
	/// - Returns: Array of `Description`
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
	
	// MARK: - CatManipulator comformance
	
	func getCat() -> CatsCard { cat }
	
	func selectCat(_ cat: CatsCard) { self.cat = cat }
	
	func deselectCat() { self.cat = nil }
}

// MARK: - Private methods
extension CatsDescriptionViewModel {
	
	/// Determine color of `CatsCard` depending on current color scheme
	/// - Returns: Current `CatsCard` color
	private func determineCatsCardsColor() -> Color {
		var colorComponents: Color.ColorComponents
		
		guard let colorScheme = colorScheme else {
			// By default light color scheme is used
			colorComponents = determineLightColorComponents()
			return Color(colorComponents)
		}
		
		switch colorScheme {
			case .dark:
				colorComponents = determineDarkColorComponents()
				
			case .light:
				colorComponents = determineLightColorComponents()
				
			default: // Default case should never be executed
				colorComponents = determineLightColorComponents()
		}
		
		return Color(colorComponents)
	}
	
	/// Determine color components for dark color scheme
	/// - Returns: Tuple of 4 values which repesents components of color (red, green, blue, alpha)
	private func determineDarkColorComponents() -> Color.ColorComponents {
		var colorComponents: Color.ColorComponents
		
		switch cat.color {
			case "Banana":
				colorComponents = (0.550, 0.526, 0.010, 1)
			case "Cantaloupe":
				colorComponents = (0.470, 0.347, 0, 1)
			case "Flora":
				colorComponents = (0.220, 0.340, 0.092, 1)
			case "Ice":
				colorComponents = (0, 0.305, 0.396, 1)
			case "Lavender":
				colorComponents = (0.269, 0.053, 0.346, 1)
			case "Orchid":
				colorComponents = (0.105, 0.043, 0.319, 1)
			case "Salmon":
				colorComponents = (0.512, 0.068, 0.001, 1)
			default:
				colorComponents = (0.090, 0.090, 0.090, 1)
		}
		
		return colorComponents
	}
	
	/// Determine color components for light color scheme
	/// - Returns: Tuple of 4 values which repesents components of color (red, green, blue, alpha)
	private func determineLightColorComponents() -> Color.ColorComponents {
		var colorComponents: Color.ColorComponents
		
		switch cat.color {
			case "Banana":
				colorComponents = (0.993, 0.986, 0.865, 1)
			case "Cantaloupe":
				colorComponents = (0.994, 0.923, 0.826, 1)
			case "Flora":
				colorComponents = (0.873, 0.931, 0.836, 1)
			case "Ice":
				colorComponents = (0.796, 0.937, 0.996, 1)
			case "Lavender":
				colorComponents = (0.936, 0.787, 0.998, 1)
			case "Orchid":
				colorComponents = (0.852, 0.784, 0.991, 1)
			case "Salmon":
				colorComponents = (0.999, 0.854, 0.849, 1)
			default:
				colorComponents = (0.894, 0.984, 1, 1)
		}
		
		return colorComponents
	}
}
