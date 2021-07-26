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
	
	@Published var textToSearch = ""
	@Published var isSortingMenu = false
	@Published var sortingKey = "name"
	@Published var isSortingAssending = true
	@Published var isMenu = false
	@Published var isEditingCatsSheet = false
	@Published var isMainCatsPageView = false
	@Published var isColorPicker = false
	@Published var isSelectedMode = false
	@Published var selectedCats: Set<CatsCard> = []
	
	@Published var pickedColor: ColorPick = .none {
		willSet(newColor) {
			if newColor == pickedColor {
				makeChanges()
			}
		}
	}

	var cardsColorPallete = (firstHalf: ColorPick.firstHalf, secondHalf: ColorPick.secondHalf)
	
	var isSelectedCatsCard: Bool { !selectedCats.isEmpty }
	
	var catsCardsColor: String {
		if let color = selectedCat.color {
			return color
		}
		return "mainColor"
	}
}

// MARK:- Public methods
extension HomeScreenViewModel {
	
	func isZeroCards(context: NSManagedObjectContext) -> Bool {
		do {
			let cards: [CatsCard] = try context.fetch(CatsCard.fetchRequest())
			return cards.isEmpty
		} catch {
			return false
		}
	}
	
	func isSearchGotNoResults(cats: FetchedResults<CatsCard>) -> Bool {
		let isNoCats = !cats.isEmpty
		let isSearchEmpty = cats.filter { validateCatsCards(cat: $0) }.isEmpty
		
		return isNoCats && isSearchEmpty
	}
	
	func validateCatsCards(cat: CatsCard) -> Bool {
		let searchingText = textToSearch.trimmingCharacters(in: .whitespacesAndNewlines)
		
		return searchingText.isEmpty || cat.wrappedName.hasPrefix(searchingText) || cat.wrappedBreed.localize().hasPrefix(searchingText) || cat.age.localize().hasPrefix(searchingText) || cat.wrappedDateOfBirth.hasPrefix(searchingText)
	}
	
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
		DispatchQueue.global(qos: .userInitiated).async { [self] in
			mainCatsPageView = MainCatsPageView(catsDescriptionViewModel: CatsDescriptionViewModel(cat: self.selectedCat, context: context))
			
			DispatchQueue.main.async {
				withAnimation(.easeInOut(duration: 0.5)) {
					isMainCatsPageView.toggle()
				}
			}
		}
	}
	
	/// Set up `EditingCatsPageView` and toggle `isEditingCatsSheet`
	/// Method is used for creating new instance of `CatsCard`
	/// - Parameter context: View context with `CatsCard` to set up `CatsCardsPageViewModel` and new instance of `CatsCard`
	func makeNewCat(context: NSManagedObjectContext) {
		DispatchQueue.global(qos: .userInitiated).async { [self] in
			let cat = CatsCard(context: context)
			cat.id = UUID()
			
			let catsCardsPageViewModel = CatsCardsPageViewModel(cat: cat, deleteAfterCancelation: true, managedObjectContext: context)
			editingCatsPageView = EditingCatsPageView(catsViewModel: catsCardsPageViewModel)
			
			DispatchQueue.main.async {
				withAnimation(.easeInOut(duration: 0.5)) {
					isEditingCatsSheet.toggle()
				}
			}
		}
	}
	
	/// Set up `EditingCatsPageView` and toggle `isMenu`, `isEditingCatsSheet`
	/// Method is used for editing previousely created instace of `CatsCard`
	/// - Parameter context: View context with `CatsCard` to set up `CatsCardsPageViewModel`
	func editCat(context: NSManagedObjectContext) {
		DispatchQueue.global(qos: .userInitiated).async { [self] in
			let catsCardsPageViewModel = CatsCardsPageViewModel(cat: selectedCat, deleteAfterCancelation: false, managedObjectContext: context)
			editingCatsPageView = EditingCatsPageView(catsViewModel: catsCardsPageViewModel)
			
			DispatchQueue.main.async {
				withAnimation(.easeInOut(duration: 0.5)) {
					isMenu.toggle()
				}
				
				withAnimation(.easeInOut(duration: 0.5)) {
					isEditingCatsSheet.toggle()
				}
			}
		}
	}
	
	/// Set up `CatsCardsColorPicker` and toggle `isMenu`, `isColorPicker`
	func changeCatsColor() {
		DispatchQueue.global(qos: .userInitiated).async { [self] in
			catsCardsColorPicker = CatsCardsColorPicker(cat: getCat(), viewModel: self)
			
			DispatchQueue.main.async {
				withAnimation(.easeInOut(duration: 0.5)) {
					isMenu.toggle()
				}
				
				withAnimation(.easeInOut(duration: 0.5)) {
					isColorPicker.toggle()
				}
			}
		}
	}
	
	/// Method is using from Menu from `HomeScreenView`
	/// Delete a `selectedCat` and toggle `isMenu`
	/// - Parameter context: View context with `CatsCard`
	func deleteCat(context: NSManagedObjectContext) {
		context.delete(selectedCat)
		
		makeChanges()
		
		deselectCat()
		
		withAnimation(.easeInOut(duration: 0.5)) {
			isMenu.toggle()
		}
	}
	
	func selectAllCats(context: NSManagedObjectContext) {
		do {
			let cats: [CatsCard] = try context.fetch(CatsCard.fetchRequest())
			
			for cat in cats {
				doOnSelect(cat: cat)
			}
			
		} catch {
			fatalError("Can't pase CoreData entities")
		}
	}
	
	func toggleSelectionMode() {
		withAnimation(.easeInOut(duration: 0.5)) {
			isSelectedMode.toggle()
			removeSelectedCats()
		}
	}
	
	func isCatSelected(cat: CatsCard) -> Double {
		isSelected(cat: cat) ? 1 : 0
	}
	
	func doOnSelect(cat: CatsCard) {
		if isSelected(cat: cat) {
			selectedCats.remove(cat)
		} else {
			selectedCats.insert(cat)
		}
	}
	
	func deleteAllSelectedCats(context: NSManagedObjectContext) {
		if isSelectedCatsCard {
			
			for cat in selectedCats {
				context.delete(cat)
			}
						
			toggleSelectionMode()
		}
	}
	
	func isSelected(cat: CatsCard) -> Bool {
		selectedCats.contains(cat)
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
	
	private func removeSelectedCats() { selectedCats.removeAll() }
	
	private func makeChanges() {
		wasChanged = true
	}
}
