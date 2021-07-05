//
//  CatsCardsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import Foundation
import SwiftUI
import CoreData

final class CatsCardsPageViewModel: CatManipulator {
	
	/// Currently edited object of `CatsCard`
	private var cat: CatsCard!
	
	var deleteAfterCancelation: Bool
	
	var managedObjectContext: NSManagedObjectContext
	
	public init(cat: CatsCard, deleteAfterCancelation: Bool = false, managedObjectContext moc: NSManagedObjectContext) {
		self.cat = cat
		self.deleteAfterCancelation = deleteAfterCancelation
		self.managedObjectContext = moc
		
		self.name = cat.name ?? ""
		self.dateOfBirth = cat.dateOfBirth ?? Date()
		self.gender = Gender(rawValue: cat.wrappedSex)!
		self.breed = cat.breed ?? BreedsViewModel.defaultBreed.name
		self.weight = cat.weight
		self.isCastrated = cat.isCastrated
		self.suppressedTail = cat.suppressedTail
		self.shortLegs = cat.shortLegs
		self.hairless = cat.hairless
		self.temperament = cat.wrappedTemperament
		self.strangerFriendly = Int(cat.strangerFriendly)
		self.childFriendly = Int(cat.childFriendly)
		self.dogFriendly = Int(cat.dogFriendly)
		self.additionalInfo = cat.wrappedInfo
		self.catsImage = UIImage(data: cat.image)
	}
	
	@Published var isAlertShown = false
	
	@Published var isImagePicker = false
	
	/// Track if changes was made to cat entity
	var wasChanged: Bool {
		!changes.values.compactMap{ $0 }.isEmpty
	}
	
	/// Holds all changes made
	private var changes: [String: Change?] = [
		"name": nil,
		"dateOfBirth": nil,
		"gender": nil,
		"breed": nil,
		"weight": nil,
		"castration": nil,
		"suppressedTail": nil,
		"shortLegs": nil,
		"hairless": nil,
		"temperament": nil,
		"strangerFriendly": nil,
		"childFriendly": nil,
		"dogFriendly": nil,
		"additionalInfo": nil,
		"image": nil
	]
	
	@Published var name: String {
		willSet(newName) {
			changes["name"] = .name(newName)
		}
	}
	
	@Published var dateOfBirth: Date {
		willSet(newDate) {
			changes["dateOfBirth"] = .dateOfBirth(newDate)
		}
	}
	
	@Published var gender: Gender {
		willSet(newGender) {
			changes["gender"] = .gender(newGender.rawValue)
		}
	}
	
	@Published var breed: String {
		willSet(newBreed) {
			changes["breed"] = .breed(newBreed)
		}
	}
	
	@Published var weight: Float {
		willSet(newWeight) {
			changes["weight"] = .weight(newWeight)
		}
	}
	
	@Published var isCastrated: Bool {
		willSet(wasCastrated) {
			changes["castration"] = .castration(wasCastrated)
		}
	}
	
	@Published var suppressedTail: Bool {
		willSet(isSuppressed) {
			changes["suppressedTail"] = .suppressedTail(isSuppressed)
		}
	}
	
	@Published var shortLegs: Bool {
		willSet(isShort) {
			changes["shortLegs"] = .shortLegs(isShort)
		}
	}
	
	@Published var hairless: Bool {
		willSet(isHairless) {
			changes["hairless"] = .hairless(isHairless)
		}
	}
	
	@Published var temperament: Temperament {
		willSet(newTemperament) {
			changes["temperament"] = .temperament(newTemperament)
		}
	}
	
	@Published var strangerFriendly: Int {
		willSet(rating) {
			changes["strangerFriendly"] = .strangerFriendly(Int16(rating))
		}
	}
	
	@Published var childFriendly: Int {
		willSet(rating) {
			changes["childFriendly"] = .childFriendly(Int16(rating))
		}
	}
	
	@Published var dogFriendly: Int {
		willSet(rating) {
			changes["dogFriendly"] = .dogFriendly(Int16(rating))
		}
	}
	
	@Published var additionalInfo: String {
		willSet(newInfo) {
			changes["additionalInfo"] = .additionalInfo(newInfo)
		}
	}
	
	@Published var catsImage: UIImage? {
		willSet(newImage) {
			if let imageData = validateImage(newImage) {
				if let downsampledImage = downsampleImage(image: imageData) {
					changes["image"] = .image(downsampledImage)
				}
			}
		}
	}
}

// MARK: - Changes tracker
extension CatsCardsPageViewModel {
	
	/// Represents type of changes
	private enum Change {
		case name(String)
		case dateOfBirth(Date)
		case gender(String)
		case breed(String)
		case weight(Float)
		case castration(Bool)
		case suppressedTail(Bool)
		case shortLegs(Bool)
		case hairless(Bool)
		case temperament(Temperament)
		case strangerFriendly(Int16)
		case childFriendly(Int16)
		case dogFriendly(Int16)
		case additionalInfo(String)
		case image(UIImage)
	}
}
	
// MARK:- Public methods
extension CatsCardsPageViewModel {
	
	func selectCat(_ cat: CatsCard) {
		self.cat = cat
	}
	
	func deselectCat() {
		self.cat = nil
	}
	
	/// Saves changes, made to instance of `CatsCard`
	func save() {
		setNewValues()
		
		do {
			try managedObjectContext.save()
		} catch {
			// TODO: Error handling
			print(error.localizedDescription)
		}
	}
	
	/// Deletes `CatsCard` object from Core Data
	/// Assigns nil to instance of `cat` and `managedObjectContext` of current `CatsCardsViewModel`
	func delete() {
		if deleteAfterCancelation {
			managedObjectContext.delete(cat)
		}
	}
	
	/// Dismisses `EditingCatsPageView` and discard or submit changes
	/// - Parameters:
	///   - isDiscardChanges: If changes should be discarded
	///   - presentation: `PresentationMode` to dismiss view
	func dismiss(isDiscardChanges: Bool = true, presentation: Binding<PresentationMode>) {
		isDiscardChanges ? delete() : save()
		deselectCat()
		presentation.wrappedValue.dismiss()
	}
}

// MARK: - Private methods
extension CatsCardsPageViewModel {
	
	/// Encode object with `JSONEncoder().encode(_:)`
	/// - Parameter obj: `Encodable` object
	/// - Returns: Encoded `Data` or `nil` if error raised
	private func encode<T: Encodable>(_ obj: T) -> Data? {
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
	private func setNew<T: Equatable>(value: T, to property: inout T) {
		property = value
	}
	
	private func validateImage(_ newImage: UIImage?) -> Data? {
		if let image = newImage {
			let imageData = image.jpegData(compressionQuality: 0.65)
			
			if imageData != cat.image {
				return imageData
			}
		}
		return nil
	}
	
	private func downsampleImage(image: Data) -> UIImage? {
		let pointSize = CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
		let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
		
		guard let imageSource = CGImageSourceCreateWithData(image as CFData, imageSourceOptions) else { return nil }
		
		let maxDimensionInPixels = max(pointSize.width, pointSize.height) * UIScreen.main.scale
		
		let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
								 kCGImageSourceShouldCacheImmediately: true,
								 kCGImageSourceCreateThumbnailWithTransform: true,
								 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
		] as CFDictionary
		
		guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
		
		return UIImage(cgImage: downsampledImage)
	}
	
	/// Sets new values if needed
	private func setNewValues() {
		for change in changes.values {
			guard let change = change else { continue }
			
			switch change {
				case let .name(name):
					setNew(value: name, to: &cat.name)

				case let .dateOfBirth(dateOfBirth):
					setNew(value: dateOfBirth, to: &cat.dateOfBirth)

				case let .gender(gender):
					setNew(value: gender, to: &cat.sex)

				case let .breed(breed):
					setNew(value: breed, to: &cat.breed)

				case let .weight(weight):
					setNew(value: weight, to: &cat.weight)

				case let .castration(isCastrated):
					setNew(value: isCastrated, to: &cat.isCastrated)

				case let .suppressedTail(suppressedTail):
					setNew(value: suppressedTail, to: &cat.suppressedTail)

				case let .shortLegs(shortLegs):
					setNew(value: shortLegs, to: &cat.shortLegs)

				case let .hairless(hairless):
					setNew(value: hairless, to: &cat.hairless)

				case let .temperament(temperament):
					if let temperamentData = encode(temperament) {
						setNew(value: temperamentData, to: &cat.temperament)
					}
					
				case let .strangerFriendly(strangerFriendly):
					setNew(value: strangerFriendly, to: &cat.strangerFriendly)

				case let .childFriendly(childFriendly):
					setNew(value: childFriendly, to: &cat.childFriendly)

				case let .dogFriendly(dogFriendly):
					setNew(value: dogFriendly, to: &cat.dogFriendly)

				case let .additionalInfo(additionalInfo):
					setNew(value: additionalInfo, to: &cat.additionalInfo)

				case let .image(catsImage):
					if let imageData = catsImage.jpegData(compressionQuality: 0.65) {
						setNew(value: imageData, to: &cat.image)
					}
			}
		}
	}
}
