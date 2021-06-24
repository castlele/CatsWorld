//
//  HomeScreenViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import Foundation

final class HomeScreenViewModel: ObservableObject {
	
	@Published var addCatSheet = false
	@Published var catsPageView: CatsPageView!
}
