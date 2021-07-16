//
//  BreedsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

/// View Model of `BreedsList`
final class BreedsViewModel: ObservableObject {
	
	private let defaultHeader = ["x-api-key": "9fa4592a-db90-46af-93d7-68743bbd52db"]
	/// ID of breed, which image is fetching righ now
	private var fetchingImageForBreedID = ""
	
	static let shared = BreedsViewModel()
	
	static var defaultBreed: Breed {
		shared.breeds[0]
	}
	
	/// Dictionary, which holds favourite breeds.
	/// Property is stored in `UserDefatults`.
	/// Key is a breed id property, value is a boolean value.
	/// Breed isn't favourite if value for curresponding key (`breed.id`) is false of if key-value pair is absent
	@Published var favBreeds: [String: Bool] = UserDefaults.standard.dictionary(forKey: "favBreeds") as? [String: Bool] ?? [:]
	
	/// Text, which is typed in `SearchBarView`
	/// It is used to search though the `breeds`
	@Published var textToSearch = ""
	@Published var isShowOnlyFavourites = false
	@Published var isLoadingBreeds = false
	@Published var isLoadingImage = false
	
	/// Current breed's image, which is shown in `BreedsDetailView`
	@Published var currentImage: Image! = nil
	@Published var isToggledAddToFavourite = false
		
	var wrappedImage: Image {
		if currentImage != nil {
			return currentImage
		}
		return Image(systemName: "person.crop.circle.fill")
	}
	
	lazy var breeds: [Breed] = {
		MockData.breeds
	}()
}

// MARK:- Public methods
extension BreedsViewModel {
	
	/// Load Breeds
	func loadBreeds() {
		isLoadingBreeds = true
		
		let url = makeURL(endPoint: EndPoint.breedsAPI([(.attachBreed, "0")]))
		
		NetworkRequester.shared.makeRequest(
			url: url!,
			headers: defaultHeader,
			completion: parseJSON(result:)
		)
	}
	
	/// Load Image for certain breed (breed, which is shown in `BreedsDetailView`)
	/// - Parameter breed: Breed, for which image should be loaded
	func loadImage(forBreed breed: Breed) {
		isLoadingImage = true
		fetchingImageForBreedID = breed.id
		
		let url = makeURL(endPoint: EndPoint.imagesAPI([(.breedID, fetchingImageForBreedID)]))
		
		NetworkRequester.shared.makeRequest(
			url: url!,
			headers: defaultHeader,
			completion: parseImageURL(result:)
		)
	}
	
	/// Filter breeds by `textToSearch`.
	/// If isShowOnlyFavourites is true, only favourite breeds will be shown
	/// - Parameter breed: Breed, which will be validated
	/// - Returns: True if `textToSearch` is emtpy or if breed is validated by `textToSearch`
	func validateBreeds(breed: Breed) -> Bool {
		if isShowOnlyFavourites {
			guard let value = favBreeds[breed.id], value else {
				return false
			}
		}
		
		let searchingText = textToSearch.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		
		return searchingText == "" || breed.name.localize().lowercased().hasPrefix(searchingText) || breed.origin.localize().lowercased().hasPrefix(searchingText)
	}
	
	/// Make breed favourite and saves that in `UserDefaults`
	/// - Parameters:
	///   - breed: Breed, which should be added to favourite
	///   - v: Optional boolean value, which should represents wheather the breed is favourite or not.
	///   If equals to nil, value will be true, if there was no such key-value pair previousely, and,if key-value exists, opposite to current value
	func makeBreedFavourite(_ breed: Breed, value v: Bool? = nil) {
		let breedID = breed.id
		var value = v
		
		if let isFavourite = favBreeds[breedID] {
			if value == nil {
				value = isFavourite ? false : true
			}
			
			favBreeds[breedID] = value
		} else {
			favBreeds[breedID] = true
		}
		
		UserDefaults.standard.set(favBreeds, forKey: "favBreeds")
	}
	
	/// Instagram like animation of appearing and disapearing heart
	func toggleAddToFavouriteAnimation() {
		withAnimation(.linear(duration: 0.3)) {
			isToggledAddToFavourite = true
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
			withAnimation(.linear(duration: 0.3)) {
				isToggledAddToFavourite = false
			}
		}
	}
}

// MARK:- Private methods
extension BreedsViewModel {
	
	/// Makes `URL`
	/// - Parameter endPoint: Instance of `EndPoint` enumeration
	/// - Returns: Optional `URL` made from `endPoint`
	private func makeURL(endPoint: EndPoint) -> URL? {
		return endPoint.url
		
	}
	
	/// Starts parsing JSON
	/// - Parameters:
	///   - data: Optional `Data` which should be parsed
	///   - error: Optional `Error` which should be handled
	///   Only one parameter can have `nil` value at the same time
	private func parseJSON(result: Result<Data, CWError>) -> Void {
		switch result {
			case .success(let data):
				JSONParser.shared.parse(from: data, completion: addBreeds(result:))
			default:
				break
		}
	}
	
	/// Adds breeds from the array and removes all mock data
	/// - Parameter breeds: Array of `Breed` which should be added
	private func addBreeds(result: Result<[Breed], CWError>) -> Void {
		DispatchQueue.main.async { [self] in
			switch result {
				case .success(let breeds):
					removeMockData()
					
					self.breeds = breeds.sorted(by: { $0.name.localize() < $1.name.localize() } )
					
					isLoadingBreeds = false
										
				default:
					break
			}
		}
	}
	
	/// Removes mock data from the `breeds` array
	private func removeMockData() {
		breeds.removeAllOccurances(MockData.breeds[0])
	}
	
	/// Use `JSONSerialization` to parse URL from JSON Data
	/// - Parameter result: JSON data if success or `CWERrror` if fail
	private func parseImageURL(result: Result<Data, CWError>) -> Void {
		switch result {
			case .success(let data):
				JSONParser.shared.parseWithSerialization(
					from: data,
					argument: "url",
					completion: getDataFromImageURL(result:)
				)
			default:
				break
		}
	}
	
	/// Validate Any result type to `URL`
	/// - Parameter result: `Any` if success or `CWError` if fail
	private func getDataFromImageURL(result: Result<Any, CWError>) -> Void {
		switch result {
			case .success(let data):
				guard let stringURL = data as? String else { break }
				guard let url = URL(string: stringURL) else { break }
				
				loadImageFromImageURL(url: url)
				
			default:
				break
		}
	}
	
	/// Load image
	/// - Parameter url: `ULR` of the image
	private func loadImageFromImageURL(url: URL) {
		NetworkRequester.shared.makeRequest(
			url: url,
			headers: nil,
			completion: convertDataToImage(result:)
		)
	}
	
	/// Downsample image and assign it to `currentImage` property
	/// - Parameter result: Image `Data` if success, `CWError` if fail
	private func convertDataToImage(result: Result<Data, CWError>) -> Void {
		DispatchQueue.main.async { [self] in
			switch result {
				case .success(let data):
					guard let uiImage = ImageProcessor.shared.downsampleImage(image: data) else { break }
					
					currentImage = Image(uiImage: uiImage)
					
					isLoadingImage = false
					
				default:
					break
			}
		}
	}
}
