//
//  CatsWorldApp.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

@main
struct CatsWorldApp: App {
	
	@StateObject private var breedsViewModel = BreedsViewModel()
	
    var body: some Scene {
        WindowGroup {
			BreedsList()
				.environmentObject(breedsViewModel)
        }
    }
}
