//
//  EditingCatsPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import SwiftUI

struct EditingCatsPageView: View {
	
	@Environment(\.presentationMode) var presentation
	@Environment(\.managedObjectContext) var persistenceController
	
	@EnvironmentObject var breedsViewModel: BreedsViewModel
	
	@StateObject var catsViewModel = CatsCardsViewModel(CatsCard(context: PersistenceController.shared.conteiner.viewContext))
	
	@State var isScrollingDown = false
	
	var isSheet = false
	
	var listOfBreeds: [Breed] {
		breedsViewModel.breeds
	}
	
	var body: some View {
		if !isSheet {
			return AnyView(VStack {
				if !isScrollingDown {
					CatsAvatar(avatar: catsViewModel.cat.wrappedImage)
						.frame(maxWidth: 150, maxHeight: 150)
				}
				
				Form {
					Section(header: Text("General information")) {
						TextField("Name", text: $catsViewModel.name)
						
						DatePicker(
							"Date of birth",
							selection: $catsViewModel.dateOfBirth, in: ...Date(),
							displayedComponents: .date
						).datePickerStyle(DefaultDatePickerStyle())
						
						Picker("What is the cat's gender", selection: $catsViewModel.gender) {
							ForEach(0..<2) { index in
								Text("\(Gender.allCases[index].rawValue.capitalized)").tag(Gender.allCases[index])
							}
						}.pickerStyle(SegmentedPickerStyle())
						
						Picker("Breed of the cat", selection: $catsViewModel.breed) {
							ForEach(listOfBreeds, id: \.name) { breed in
								Text("\(breed.name)")
							}
						}.pickerStyle(InlinePickerStyle())
					}
					
					Section(header: Text("Physical aspects")) {
						
						Toggle("Enable the section", isOn: $catsViewModel.isPhysicalSectionEnabled.animation())
						
						if catsViewModel.isPhysicalSectionEnabled {
							HStack {
								Text("Weight \(catsViewModel.weight, specifier: "%.1f") kg")
								
								Spacer()
								
								Slider(value: $catsViewModel.weight, in: 0...50)
							}
							
							Toggle("Is castrated", isOn: $catsViewModel.isCastrated)
							
							Toggle("Is the tail suppressed", isOn: $catsViewModel.suppressedTail)
							
							Toggle("Is the legs are short", isOn: $catsViewModel.shortLegs)
							
							Toggle("Is hair less", isOn: $catsViewModel.hairless)
						}
					}
					
					Section(header: Text("Psycological aspects")) {
						Toggle("Enable the section", isOn: $catsViewModel.isPsycolocicalSectionEnabled.animation())
						
						if catsViewModel.isPsycolocicalSectionEnabled {
							Picker("Temperament", selection: $catsViewModel.temperament) {
								ForEach(Temperament.allCases, id: \.self) { temperament in
									Text("\(temperament.rawValue.capitalized)")
								}
							}.pickerStyle(SegmentedPickerStyle())
							
							RatingView(rating: $catsViewModel.strangerFriendly,
									   label: "Stranger friendly",
									   offImage: Image(systemName: "star"),
									   onImage: Image(systemName: "star.fill")
							)
							
							RatingView(rating: $catsViewModel.childFriendly,
									   label: "Child friendly",
									   offImage: Image(systemName: "star"),
									   onImage: Image(systemName: "star.fill")
							)
							
							RatingView(rating: $catsViewModel.dogFriendly,
									   label: "Child friendly",
									   offImage: Image(systemName: "star"),
									   onImage: Image(systemName: "star.fill")
							)
						}
					}
					
					Section(header: Text("Additional information"), footer: Text("Write anything you want about your fluffy friend!")) {
						MultilineTextFieldView(text: $catsViewModel.additionalInfo, placeholder: "Write here")
					}
				}
			}
			.checkIfScrolling(isScrolling: $isScrollingDown)
			.hideKeyboardGesture()
			)
		
		} else {
			return AnyView(NavigationView {
				
			})
		}
	}
}

struct EditingCatsPageView_Previews: PreviewProvider {
    static var previews: some View {
        EditingCatsPageView()
    }
}
