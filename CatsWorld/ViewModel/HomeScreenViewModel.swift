//
//  HomeScreenViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI
import CoreData

/// View Model of `HomeScreenView`
final class HomeScreenViewModel: CatManipulator {
	
	/// Shows if changes were made to `selectedCat`
	private var wasChanged = false
	private var selectedCat: CatsCard!
		
	var editingCatsPageView: EditingCatsPageView!
	var mainCatsPageView: MainCatsPageView!
	var catsCardsColorPicker: CatsCardsColorPicker!
	
	@Published var isMenu = false
	@Published var isEditingCatsSheet = false
	@Published var isMainCatsPageView = false
	@Published var isColorPicker = false
	
	@Published var pickedColor: ColorPick = .none {
		willSet(newColor) {
			if newColor == pickedColor {
				makeChanges()
			}
		}
	}
	
	var catsCardsColor: String {
		if let color = selectedCat.color {
			return color
		}
		return "mainColor"
	}
	
	var cardsColorPallete = (firstHalf: ColorPick.firstHalf, secondHalf: ColorPick.secondHalf)
}

// MARK:- Public methods
extension HomeScreenViewModel {
	
	/// Save changes of `context` if changes were made
	/// To determine weather changes were made there is a private property `wasChanged`
	/// - Parameter context: View context which changes should be saved
	func saveChanges(context: NSManagedObjectContext) {
		if wasChanged {
			DispatchQueue.global().async {
				do {
					try context.save()
				} catch {
					#if DEBUG
					print("\(error.localizedDescription)")
					#endif
				}
			}
		}
	}
	
	/// Set `wasChanged` to false
	func resetChanges() {
		wasChanged = false
	}
	
	/// Set up `MainCatsPageView` and toggle `isMainCatsPageView`
	/// - Parameter context: View context with `CatsCard` to set up `CatsDescriptionViewModel`
	func observeCat(context: NSManagedObjectContext) {
		mainCatsPageView = MainCatsPageView(catsDescriptionViewModel: CatsDescriptionViewModel(cat: self.selectedCat, context: context))
		
		isMainCatsPageView.toggle()
	}
	
	/// Set up `EditingCatsPageView` and toggle `isEditingCatsSheet`
	/// Method is used for creating new instance of `CatsCard`
	/// - Parameter context: View context with `CatsCard` to set up `CatsCardsPageViewModel` and new instance of `CatsCard`
	func makeNewCat(context: NSManagedObjectContext) {
		let cat = CatsCard(context: context)
		let catsCardsPageViewModel = CatsCardsPageViewModel(cat: cat, deleteAfterCancelation: true, managedObjectContext: context)
		editingCatsPageView = EditingCatsPageView(catsViewModel: catsCardsPageViewModel)
		
		isEditingCatsSheet.toggle()
	}
	
	/// Set up `EditingCatsPageView` and toggle `isMenu`, `isEditingCatsSheet`
	/// Method is used for editing previousely created instace of `CatsCard`
	/// - Parameter context: View context with `CatsCard` to set up `CatsCardsPageViewModel`
	func editCat(context: NSManagedObjectContext) {
		let catsCardsPageViewModel = CatsCardsPageViewModel(cat: selectedCat, deleteAfterCancelation: false, managedObjectContext: context)
		editingCatsPageView = EditingCatsPageView(catsViewModel: catsCardsPageViewModel)
		
		isMenu.toggle()
		isEditingCatsSheet.toggle()
	}
	
	/// Set up `CatsCardsColorPicker` and toggle `isMenu`, `isColorPicker`
	func changeCatsColor() {
		catsCardsColorPicker = CatsCardsColorPicker(cat: getCat(), viewModel: self)
		
		isMenu.toggle()
		isColorPicker.toggle()
	}
	
	/// Method is using from Menu from `HomeScreenView`
	/// Delete a `selectedCat` and toggle `isMenu`
	/// - Parameter context: View context with `CatsCard`
	func deleteCat(context: NSManagedObjectContext) {
		context.delete(selectedCat)
		
		makeChanges()
		
		deselectCat()
		
		withAnimation() {
			isMenu.toggle()
		}
	}
	
	// MARK: - CatsManipulator protocol comformance
	
	/// Return currently selected cat
	/// - Returns: `selectedCat`
	func getCat() -> CatsCard { selectedCat }
	
	/// Assign new `CatsCard` to `selectedCat`
	func selectCat(_ cat: CatsCard) { selectedCat = cat }
	
	/// Remove currently selected cat
	/// Assigns `nil` value to `selectedCat`
	func deselectCat() { selectedCat = nil }
}

// MARK: - Private methods
extension HomeScreenViewModel {
	
	private func makeChanges() {
		wasChanged = true
	}
}
