//
//  CatsCardsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import Foundation
import SwiftUI
import CoreData

/// View Model of `EditingCatsPageView`
final class CatsCardsPageViewModel: CatManipulator {
	
	/// Currently edited object of `CatsCard`
	private var cat: CatsCard!
	
	/// Holds all changes to private `cat` property
	/// The format of traking changes is key-value pairs
	/// Key is a property name of `CatsCard` instance
	/// Value is optional representation of changes of type `CatsCardsPageViewModel.Change`
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
		"character": nil,
		"temperament": nil,
		"strangerFriendly": nil,
		"childFriendly": nil,
		"dogFriendly": nil,
		"additionalInfo": nil,
		"image": nil
	]
	
	/// If true, after cancelation of `EditingCatsPageView` private `cat` property will be deleted
	/// Otherwise, it will be saved
	var deleteAfterCancelation: Bool
	var managedObjectContext: NSManagedObjectContext
	var alertToShow: Alert!
	
	@Published var currentCharacter = ""
	@Published var isOnDeleteCharacter = false
	@Published var isAlertShown = false
	@Published var isImagePickerStyle = false
	@Published var isImagePicker = false
	@Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
	
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
	
	@Published var character: [String] {
		didSet {
			changes["character"] = .character(character)
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
				if let downsampledImage = ImageProcessor.shared.downsampleImage(image: imageData) {
					changes["image"] = .image(downsampledImage)
				}
			}
		}
	}
	
	/// Track if changes were made to private `cat` property
	/// True means that values of private `changes` dictionary are all have nil value
	var wasChanged: Bool {
		!changes.values.compactMap{ $0 }.isEmpty
	}
	
	// MARK: - Initialization
	public init(cat: CatsCard, deleteAfterCancelation: Bool = false, managedObjectContext moc: NSManagedObjectContext) {
		self.cat = cat
		self.deleteAfterCancelation = deleteAfterCancelation
		self.managedObjectContext = moc
		
		// Setting up of @Published properties
		self.name = cat.name ?? ""
		self.dateOfBirth = cat.dateOfBirth ?? Date()
		self.gender = Gender(rawValue: cat.wrappedSex)! // It is safe to force unwrap
		self.breed = cat.breed ?? BreedsViewModel.defaultBreed.name
		self.weight = cat.weight
		self.isCastrated = cat.isCastrated
		self.suppressedTail = cat.suppressedTail
		self.shortLegs = cat.shortLegs
		self.hairless = cat.hairless
		self.character = cat.getListOfCharacter()
		self.temperament = cat.wrappedTemperament
		self.strangerFriendly = Int(cat.strangerFriendly)
		self.childFriendly = Int(cat.childFriendly)
		self.dogFriendly = Int(cat.dogFriendly)
		self.additionalInfo = cat.wrappedInfo
		self.catsImage = UIImage(data: cat.image)
	}
}

// MARK: - Changes tracker
extension CatsCardsPageViewModel {
	
	/// Represents changes, that can be done to every property of `CatsCard` instance
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
		case character([String])
		case temperament(Temperament)
		case strangerFriendly(Int16)
		case childFriendly(Int16)
		case dogFriendly(Int16)
		case additionalInfo(String)
		case image(UIImage)
	}
}

// MARK: - Alert Type
extension CatsCardsPageViewModel {
	
	enum AlertType {
		case delete
		case cancel
	}
}
	
// MARK:- Public methods
extension CatsCardsPageViewModel {
	
	func makeAlert(type: AlertType, presentation: Binding<PresentationMode>) {
		switch type {
			case .cancel:
				alertToShow = Alert(
					title: Text("Discarding changes"),
					message: Text("Sure wanna discard"),
					primaryButton: .default(Text("Discard"),
											action: { [self] in
												dismiss(presentation: presentation)
												alertToShow = nil
											}),
					secondaryButton: .cancel({ self.alertToShow = nil })
				)
			case .delete:
				alertToShow = Alert(
					title: Text("Deleting a card"),
					message: Text("Are you sure, you want to delete currently editing cat"),
					primaryButton: .destructive(Text("Delete"),
												action: { [self] in
													deleteCat(presentation: presentation)
													alertToShow = nil
												}),
					secondaryButton: .cancel({ self.alertToShow = nil })
				)
		}
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
	func delete() {
		if deleteAfterCancelation {
			managedObjectContext.delete(cat)
		}
	}
	
	/// Dismisses `EditingCatsPageView`
	/// - Parameters:
	///   - isDiscardChanges: If changes should be discarded
	///   - presentation: `PresentationMode` to dismiss view
	func dismiss(isDiscardChanges: Bool = true, presentation: Binding<PresentationMode>) {
		isDiscardChanges ? delete() : save()
		deselectCat()
		presentation.wrappedValue.dismiss()
	}
	
	func deleteCat(presentation: Binding<PresentationMode>) {
		managedObjectContext.delete(cat)
		deselectCat()
		presentation.wrappedValue.dismiss()
	}
	
	// MARK: - CatManipulator comformance
	
	func selectCat(_ cat: CatsCard) {
		self.cat = cat
	}
	
	func deselectCat() {
		self.cat = nil
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
	
	/// Set new value to `cat`'s property
	/// - Parameters:
	///   - value: New value to assign
	///   - property: Cat's property to assign to
	private func setNew<T: Equatable>(value: T, to property: inout T) {
		property = value
	}
	
	/// Check if new image is valid, compresses new image's data and checks if new image isn't equal to old value of `cat.image`
	/// - Parameter newImage: New image, which is assigning to `cat.image` property
	/// - Returns: `Data` if image is valid and isn't equal to old image, otherwise, nil
	private func validateImage(_ newImage: UIImage?) -> Data? {
		if let image = newImage {
			let imageData = image.jpegData(compressionQuality: 0.65)
			
			if imageData != cat.image {
				return imageData
			}
		}
		return nil
	}
	
	/// Sets new values to `CatsCard` corresponding properties if needed
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

				case let .character(listOfCharacter):
					let strCharacter = listOfCharacter.joined(separator: ", ")
					setNew(value: strCharacter, to: &cat.character)
					
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
