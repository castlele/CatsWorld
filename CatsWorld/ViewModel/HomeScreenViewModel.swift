//
//  HomeScreenViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI
import CoreData

final class HomeScreenViewModel: CatManipulator {
		
	private var wasChanged = false
	private var selectedCat: CatsCard!
		
	var editingCatsPageView: EditingCatsPageView!
	var mainCatsPageView: MainCatsPageView!
	var catsCardsColorPicker: CatsCardsColorPicker!
	
	@Published var isEditingCatsSheet = false
	@Published var isMainCatsPageView = false
	@Published var isColorPicker = false
	@Published var isMenu = false
	
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
	
	func resetChanges() {
		wasChanged = false
	}
	
	func observeCat(context: NSManagedObjectContext) {
		mainCatsPageView = MainCatsPageView(catsDescriptionViewModel: CatsDescriptionViewModel(cat: self.selectedCat, context: context))
		
		isMainCatsPageView.toggle()
	}
	
	func makeNewCat(context: NSManagedObjectContext) {
		let cat = CatsCard(context: context)
		let catsCardsPageViewModel = CatsCardsPageViewModel(cat: cat, deleteAfterCancelation: true, managedObjectContext: context)
		editingCatsPageView = EditingCatsPageView(catsViewModel: catsCardsPageViewModel)
		
		isEditingCatsSheet.toggle()
	}
	
	func editCat(context: NSManagedObjectContext) {
		let catsCardsPageViewModel = CatsCardsPageViewModel(cat: selectedCat, deleteAfterCancelation: false, managedObjectContext: context)
		editingCatsPageView = EditingCatsPageView(catsViewModel: catsCardsPageViewModel)
		
		isMenu.toggle()
		isEditingCatsSheet.toggle()
	}
	
	func changeCatsColor() {
		catsCardsColorPicker = CatsCardsColorPicker(cat: getCat(), viewModel: self)
		
		isMenu.toggle()
		isColorPicker.toggle()
	}
	
	func deleteCat(context: NSManagedObjectContext) {
		context.delete(selectedCat)
		
		deselectCat()
		
		withAnimation() {
			isMenu.toggle()
		}
	}
	
	func getCat() -> CatsCard { selectedCat }
	
	func selectCat(_ cat: CatsCard) { selectedCat = cat }
	
	func deselectCat() { selectedCat = nil }
}

// MARK: - Private methods
extension HomeScreenViewModel {
	
	private func makeChanges() {
		wasChanged = true
	}
}
