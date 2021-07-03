//
//  HomeScreenViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI
import CoreData

final class HomeScreenViewModel: CatManipulator {
	
	private var selectedCat: CatsCard!
	
	var editingCatsPageView: EditingCatsPageView!
	var mainCatsPageView: MainCatsPageView!
	var catsCardsColorPicker: CatsCardsColorPicker!
		
	@Published var isAddCatSheet = false
	@Published var isMainCatsPageView = false
	@Published var isColorPicker = false
	
	var catsCardsColor: Color {
		Color(selectedCat.wrappedColor)
	}
}

// MARK:- Public methods
extension HomeScreenViewModel {
	
	func saveChangesIf(_ expression: Bool, context: NSManagedObjectContext) {
		if expression {
			print("Save")
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
	
	func observeCat(context: NSManagedObjectContext) {
		mainCatsPageView = MainCatsPageView(catsDescriptionViewModel: CatsDescriptionViewModel(cat: self.selectedCat, context: context))
		
		isMainCatsPageView.toggle()
	}
	
	func makeNewCat(context: NSManagedObjectContext) {
		let cat = CatsCard(context: context)
		let catsCardsPageViewModel = CatsCardsPageViewModel(cat: cat, deleteAfterCancelation: true, managedObjectContext: context)
		editingCatsPageView = EditingCatsPageView(catsViewModel: catsCardsPageViewModel)
		
		isAddCatSheet.toggle()
	}
	
	func changeCatsColor() {
		catsCardsColorPicker = CatsCardsColorPicker(cat: selectedCat, pickedColor: catsCardsColor, viewModel: self)
		
		isColorPicker.toggle()
	}
	
	func selectCat(_ cat: CatsCard) { selectedCat = cat }
	
	func deselectCat() { selectedCat = nil }
}
