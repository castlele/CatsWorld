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
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@StateObject var catsViewModel = CatsCardsViewModel()
	
	var cat: CatsCard
	var breedsViewModel: BreedsViewModel
	
	var body: some View {
		NavigationView {
			VStack {
				if !catsViewModel.isScrollingDown {
					CatsAvatar(avatar: UIImage(systemName: "person.crop.circle.fill")!	)
						.frame(maxWidth: 150, maxHeight: 150)
						.padding(.top)
				}
				
				Form {
					Section(header: Text("General information")) {
						TextField("Name", text: $catsViewModel.name)
						
						DatePicker(
							"Date of birth",
							selection: $catsViewModel.dateOfBirth, in: ...Date(),
							displayedComponents: .date
						).datePickerStyle(DefaultDatePickerStyle())
						
						Picker("What is the wrappedCat's gender", selection: $catsViewModel.gender) {
							ForEach(0..<2) { index in
								Text("\(Gender.allCases[index].rawValue.capitalized)").tag(Gender.allCases[index])
							}
						}.pickerStyle(SegmentedPickerStyle())
						
						Picker("Breed of the wrappedCat", selection: $catsViewModel.breed) {
							ForEach(breedsViewModel.breeds, id: \.name) { breed in
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
			.checkIfScrolling(isScrolling: $catsViewModel.isScrollingDown)
			.hideKeyboardGesture()
			.navigationBarItems(
				leading: CancelButton(
					presentation: presentation,
					showAlert: $catsViewModel.isAlertOfCanceling,
					isEditing: .constant(false),
					wasChanges: catsViewModel.wasChanged) {
					catsViewModel.dismiss(presentation: presentation)
					
				}, trailing: DoneButton(presentation: presentation) {
					catsViewModel.dismiss(isDiscardChanges: false, presentation: presentation)
				})
			.alert(isPresented: $catsViewModel.isAlertOfCanceling) {
				// TODO:- Redo Alert with Error handling
				Alert(
					title: Text("Discarding changes"),
					message: Text("Are you sure you want to discard this new card"),
					primaryButton: .default(Text("Discard"), action: { catsViewModel.dismiss(presentation: presentation) }),
					secondaryButton: .cancel())
			}
		}
		.onAppear() {
			DispatchQueue.main.async {
				self.breedsViewModel.loadBreeds()
			}
			catsViewModel.cat = cat
			catsViewModel.managedObjectContext = managedObjectContext
		}
	}
}

struct EditingCatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		EditingCatsPageView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), breedsViewModel: BreedsViewModel.shared)
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
