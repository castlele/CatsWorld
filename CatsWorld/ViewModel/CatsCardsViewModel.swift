//
//  CatsCardsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI

final class CatsCardsViewModel: ObservableObject {
	
	@Published var isCatsPageView = false
	@Published var isEditingCatsPage = false
	@Published var isColorPicker = false
}
