//
//  CatsCardsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import Foundation
import SwiftUI
import CoreData

final class CatsCardsViewModel: ObservableObject {
	
	@Published var isAlertOfCanceling = false
	@Published var isScrollingDown = false
	
	/// Currently edited object of `CatsCard`
	var cat: CatsCard!
	var managedObjectContext: NSManagedObjectContext!
	
	/// Track if changes was made to cat entity
	@Published var wasChanged = false
	
	@Published var name = "" {
		willSet(newName) {
			print(newName)
			guard let cat = cat else { return }
			setNew(value: newName, to: &cat.name)
		}
	}
	
	@Published var dateOfBirth: Date = Date() {
		willSet(newDate) {
			guard let cat = cat else { return }
			setNew(value: newDate, to: &cat.dateOfBirth)
		}
	}
	
	@Published var gender: Gender = .female {
		willSet(newGender) {
			guard let cat = cat else { return }
			setNew(value: newGender.rawValue, to: &cat.sex)
		}
	}
	
	@Published var breed: String = BreedsViewModel.defaultBreed.name {
		willSet(newBreed) {
			guard let cat = cat else { return }
			setNew(value: newBreed, to: &cat.breed)
		}
	}
	
	@Published var isPhysicalSectionEnabled = false {
		willSet(isSection) {
			guard let cat = cat else { return }
			setNew(value: isSection, to: &cat.isPhysicalSectionEnabled)
		}
	}
	
	@Published var weight: Float = 1 {
		willSet(newWeight) {
			guard let cat = cat else { return }
			setNew(value: newWeight, to: &cat.weight)
		}
	}
	
	@Published var isCastrated = false {
		willSet(wasCastrated) {
			guard let cat = cat else { return }
			setNew(value: wasCastrated, to: &cat.isCastrated)
		}
	}
	
	@Published var suppressedTail = false {
		willSet(isSuppressed) {
			guard let cat = cat else { return }
			setNew(value: isSuppressed, to: &cat.suppressedTail)
		}
	}
	
	@Published var shortLegs = false {
		willSet(isShort) {
			guard let cat = cat else { return }
			setNew(value: isShort, to: &cat.shortLegs)
		}
	}
	
	@Published var hairless = false {
		willSet(isHairless) {
			guard let cat = cat else { return }
			setNew(value: isHairless, to: &cat.hairless)
		}
	}
	
	@Published var isPsycolocicalSectionEnabled = false {
		willSet(isSection) {
			guard let cat = cat else { return }
			setNew(value: isSection, to: &cat.isPsycolocicalSectionEnabled)
		}
	}
	
	@Published var temperament: Temperament = .choleric {
		willSet(newTemperament) {
			guard let cat = cat else { return }
			if let data = encode(newTemperament) {
				setNew(value: data, to: &cat.temperament)
			}
		}
	}
	
	@Published var strangerFriendly = 1 {
		willSet(rating) {
			guard let cat = cat else { return }
			setNew(value: Int16(rating), to: &cat.strangerFriendly)
		}
	}
	
	@Published var childFriendly = 1 {
		willSet(rating) {
			guard let cat = cat else { return }
			setNew(value: Int16(rating), to: &cat.childFriendly)
		}
	}
	
	@Published var dogFriendly = 1 {
		willSet(rating) {
			guard let cat = cat else { return }
			setNew(value: Int16(rating), to: &cat.dogFriendly)
		}
	}
	
	@Published var additionalInfo = "" {
		willSet(newInfo) {
			guard let cat = cat else { return }
			setNew(value: newInfo, to: &cat.additionalInfo)
		}
	}
}
	
// MARK:- Helper methods
extension CatsCardsViewModel {
	
	/// Saves changes, made to instance of `CatsCard`
	func save() {
		guard let _ = cat else { return }
		
		do {
			try managedObjectContext.save()
		} catch {
			// TODO: Error handling
			print(error.localizedDescription)
		}
		
		self.cat = nil
		self.managedObjectContext = nil
	}
	
	/// Deletes `CatsCard` object from Core Data
	/// Assigns nil to instance of `cat` and `managedObjectContext` of current `CatsCardsViewModel`
	func delete() {
		guard let cat = cat else { return }
		
		managedObjectContext.delete(cat)
		
		self.cat = nil
		self.managedObjectContext = nil
	}
	
	/// Dismisses `EditingCatsPageView` and discard or submit changes
	/// - Parameters:
	///   - isDiscardChanges: If changes, made should be discarded
	///   - presentation: `PresentationMode` to dismiss view
	func dismiss(isDiscardChanges: Bool = true, presentation: Binding<PresentationMode>) {
		isDiscardChanges ? delete() : save()
		presentation.wrappedValue.dismiss()
	}
	
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
