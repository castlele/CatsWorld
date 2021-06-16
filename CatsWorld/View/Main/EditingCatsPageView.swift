//
//  EditingCatsPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import SwiftUI
import CoreData

struct EditingCatsPageView: View {
	
	@Environment(\.presentationMode) var presentation
	
	@StateObject var catsViewModel: CatsCardsViewModel
	
	var body: some View {
		NavigationView {
			Form {
				VStack {
					HStack {
						Spacer()
						
						CatsAvatar(avatar: catsViewModel.catsImage ?? UIImage(systemName: "person.crop.circle.fill")!)
							.frame(minWidth: 40, maxWidth: 100, minHeight: 40, maxHeight: 100)
						
						Spacer()
					}
					
					Button("Add photo") {
						catsViewModel.isImagePicker.toggle()
					}
				}
				.listRowBackground(Color.clear)

				
				Section(header: Text("General information")) {
					TextField("Name", text: $catsViewModel.name)
					
					DatePicker(
						"Date of birth",
						selection: $catsViewModel.dateOfBirth, in: ...Date(),
						displayedComponents: .date
					)
					.datePickerStyle(DefaultDatePickerStyle())
					
					Picker("What is the wrappedCat's gender", selection: $catsViewModel.gender) {
						ForEach(0..<2) { index in
							Text("\(Gender.allCases[index].rawValue.capitalized)").tag(Gender.allCases[index])
						}
					}
					.pickerStyle(SegmentedPickerStyle())
					
					Picker("Breed of the wrappedCat", selection: $catsViewModel.breed) {
						ForEach(BreedsViewModel.shared.breeds, id: \.name) { breed in
							Text("\(breed.name)")
						}
					}
					.pickerStyle(InlinePickerStyle())
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
						}
						.pickerStyle(SegmentedPickerStyle())
						
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
								   label: "Dog friendly",
								   offImage: Image(systemName: "star"),
								   onImage: Image(systemName: "star.fill")
						)
					}
				}
				
				Section(header: Text("Additional information"), footer: Text("Write anything you want about your fluffy friend!")) {
					TextEditor(text: $catsViewModel.additionalInfo)
				}
				.listRowInsets(.init())
			}
			.navigationBarItems(
				leading: CancelButton(
					presentation: presentation,
					showAlert: $catsViewModel.isAlertShown,
					wasChanges: catsViewModel.wasChanged) {
					catsViewModel.dismiss(presentation: presentation)
					
				}, trailing: DoneButton(presentation: presentation) {
					catsViewModel.dismiss(isDiscardChanges: false, presentation: presentation)
				})
			.alert(isPresented: $catsViewModel.isAlertShown) {
				// TODO:- Redo Alert with Error handling
				Alert(
					title: Text("Discarding changes"),
					message: Text("Are you sure you want to discard this new card"),
					primaryButton: .default(Text("Discard"), action: { catsViewModel.dismiss(presentation: presentation) }),
					secondaryButton: .cancel())
			}
		}
		.sheet(isPresented: $catsViewModel.isImagePicker) {
			ImagePicker(image: $catsViewModel.catsImage)
		}
		.onDisappear {
			catsViewModel.dismiss(isDiscardChanges: true, presentation: presentation)
		}
	}
}

struct EditingCatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		EditingCatsPageView(catsViewModel: CatsCardsViewModel(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), managedObjectContext: PersistenceController.preview.conteiner.viewContext))
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
