//
//  CatsCardsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import Foundation
import SwiftUI

final class CatsCardsViewModel: ObservableObject {
	
	var cat: CatsCard
	
	/// Track is changes was made to cat entity
	var wasChanged = false
	
	init(_ cat: CatsCard) {
		self.cat = cat
	}
	
	@Published var name = "" {
		didSet(newName) {
			setNew(value: newName, to: &cat.name)
		}
	}
	
	@Published var dateOfBirth: Date = Date() {
		didSet(newDate) {
			setNew(value: newDate, to: &cat.dateOfBirth)
		}
	}
	
	@Published var gender: Gender = .female {
		didSet(newGender) {
			setNew(value: newGender.rawValue, to: &cat.sex)
		}
	}
	
	@Published var breed: String = BreedsViewModel.defaultBreed.name {
		didSet(newBreed) {
			setNew(value: newBreed, to: &cat.breed)
		}
	}
	
	@Published var isPhysicalSectionEnabled = false {
		didSet(isSection) {
			setNew(value: isSection, to: &cat.isPhysicalSectionEnabled)
		}
	}
	
	@Published var weight: Float = 1 {
		willSet(newWeight) {
			setNew(value: newWeight, to: &cat.weight)
		}
	}
	
	@Published var isCastrated = false {
		didSet(wasCastrated) {
			setNew(value: wasCastrated, to: &cat.isCastrated)
		}
	}
	
	@Published var suppressedTail = false {
		didSet(isSuppressed) {
			setNew(value: isSuppressed, to: &cat.suppressedTail)
		}
	}
	
	@Published var shortLegs = false {
		didSet(isShort) {
			setNew(value: isShort, to: &cat.shortLegs)
		}
	}
	
	@Published var hairless = false {
		didSet(isHairless) {
			setNew(value: isHairless, to: &cat.hairless)
		}
	}
	
	@Published var isPsycolocicalSectionEnabled = false {
		didSet(isSection) {
			setNew(value: isSection, to: &cat.isPsycolocicalSectionEnabled)
		}
	}
	
	@Published var temperament: Temperament = .choleric {
		didSet(newTemperament) {
			if let data = encode(newTemperament) {
				setNew(value: data, to: &cat.temperament)
			}
		}
	}
	
	@Published var strangerFriendly = 1 {
		didSet(rating) {
			setNew(value: Int16(rating), to: &cat.strangerFriendly)
		}
	}
	
	@Published var childFriendly = 1 {
		didSet(rating) {
			setNew(value: Int16(rating), to: &cat.childFriendly)
		}
	}
	
	@Published var dogFriendly = 1 {
		didSet(rating) {
			setNew(value: Int16(rating), to: &cat.dogFriendly)
		}
	}
	
	@Published var additionalInfo = "" {
		didSet(newInfo) {
			setNew(value: newInfo, to: &cat.additionalInfo)
		}
	}
}
	
// MARK:- Helper methods
extension CatsCardsViewModel {
	
	/// Encode object with `JSONEncoder().encode(_:)`
	/// - Parameter obj: `Encodable` object
	/// - Returns: Encoded `Data` or `nil` if error raised
	func encode<T: Encodable>(_ obj: T) -> Data? {
		do {
			let data = try JSONEncoder().encode(obj)
			return data
		} catch {
			return nil
		}
	}
	
	/// Set new value to cat's property
	/// - Parameters:
	///   - value: New value to assign
	///   - property: Cat's property to assign to
	func setNew<T: Equatable>(value: T, to property: inout T) {
		if makeChangesIf(value != property) {
			property = value
		}
	}
	
	/// Defines if changes were made and changes tracker `wasChanged` respectively
	/// - Parameters:
	///   - expression: Expression on which changes track
	/// - Returns: `true` if changes were made else `false`
	func makeChangesIf(_ expression: Bool) -> Bool {
		if expression {
			wasChanged = true
			return true
			
		} else {
			wasChanged = false
			return false
		}
	}
}
