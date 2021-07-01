//
//  HomeScreenViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI

final class HomeScreenViewModel: ObservableObject {
		
	@Published var addCatSheet = false
	@Published var catsPageView: CatsPageView!
	@Published var isCatsPageView = false
	
	@Published var isColorPicker = false
	@Published var selectedCat: CatsCard!
	
	var catsCardsColor: Color {
		Color(selectedCat.wrappedColor)
	}
}

// MARK:- Public methods
extension HomeScreenViewModel {
	func selectCat(_ cat: CatsCard) { selectedCat = cat }
}
