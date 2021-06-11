//
//  CatsDescriptionViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct Setting: Identifiable {
	var name: String
	var value: CatsDescriptionValue
	
	var id = UUID()
	
	init(_ name: String, _ value: CatsDescriptionValue) {
		self.name = name
		self.value = value
	}
}

final class CatsDescriptionViewModel: ObservableObject {
	
	var cat: CatsCard
	
	@Published var category: CatsDescriptionCategory = .physical
	
	var currentSettings: [Setting] {
		determineSettings(for: self.category)
	}
	
	init(cat: CatsCard) {
		self.cat = cat
	}
}

// MARK: - Public methods
extension CatsDescriptionViewModel {
	func settingsFor(category: CatsDescriptionCategory) -> [Setting] {
		determineSettings(for: category)
	}
}
	
// MARK:- Private methods
extension CatsDescriptionViewModel {
	
	private func determineSettings(for category: CatsDescriptionCategory) -> [Setting] {
		switch category {
			case .physical:
				return
					[
						Setting("Suppressed tail", .bool(cat.suppressedTail)),
						Setting("Short legs", .bool(cat.shortLegs)),
						Setting("Hairless", .bool(cat.hairless)),
						Setting("Weight", .float(cat.weight)),
						Setting("Castrated", .bool(cat.isCastrated))
					]
				
			case .psycological:
				return
					[
						Setting("Stranger friendly", .int(cat.strangerFriendly)),
						Setting("Child friendly", .int(cat.childFriendly)),
						Setting("Dog friendly", .int(cat.dogFriendly)),
						Setting("Temperament", .temperament(cat.wrappedTemperament)),
					]
				
			case .shows:
				return
					[
						Setting("Cat shows", .showsArray(cat.wrappedCatShows)),
					]
				
		}
	}
}
