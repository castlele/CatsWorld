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
	
	@StateObject var catsViewModel: CatsCardsPageViewModel
	
	var body: some View {
		VStack {
			TopBarView(maxHeight: 100, leading: {
				CancelButton(
					showAlert: $catsViewModel.isAlertShown,
					wasChanges: catsViewModel.wasChanged,
					action: {
						catsViewModel.dismiss(presentation: presentation)
					}, content: {
						Image3D(
							topView: Image(systemName: "xmark"),
							bottomView: Image(systemName: "xmark"),
							topColor: .white,
							bottomColor: Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
						)
					})
					.frame(width: 50, height: 50)
					.buttonStyle(CircleButtonStyle())
					.padding([.top, .leading])
				
			}, trailing: {
				DoneButton(action: {
					catsViewModel.dismiss(isDiscardChanges: false, presentation: presentation)
					
				}, content: {
					View3D(
					topView:  PawView().scale(0.8),
					bottomView:  PawView().scale(0.8),
					topColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
					bottomColor: .gray)
			   })
				.frame(width: 50, height: 50)
				.buttonStyle(CircleButtonStyle())
				.padding([.top, .trailing])
			})
			
			ScrollView {
				CatsAvatar(avatar: catsViewModel.catsImage)
					.frame(width: 150, height: 150)
					.background(EarsView())
					.padding(.top)
					.simultaneousGesture(
						TapGesture()
							.onEnded { _ in
								catsViewModel.isImagePicker.toggle()
							}
					)
				
				// MARK:- Main info section
				CatsDescriptionSection(backgroundColor: .white) {
					TextField("Name", text: $catsViewModel.name)
						.disableAutocorrection(true)
					
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
				
				// MARK:- Physical section
				CatsDescriptionSection(backgroundColor: .white) {
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
				
				// MARK:- Psycological section
				CatsDescriptionSection(backgroundColor: .white) {
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
				
				// MARK:- More info section
				CatsDescriptionSection(backgroundColor: .white) {
					TextEditor(text: $catsViewModel.additionalInfo)
						.overlay(catsViewModel.additionalInfo.isEmpty ? Text("Write whatever you want about your cat") : nil)
				}
			}
			.frame(width: UIScreen.screenWidth)
			.volumetricShadows()
		}
		.alert(isPresented: $catsViewModel.isAlertShown) {
			// TODO:- Redo Alert with Error handling
			Alert(
				title: Text("Discarding changes"),
				message: Text("Are you sure you want to discard this new card"),
				primaryButton: .default(Text("Discard"), action: { catsViewModel.dismiss(presentation: presentation) }),
				secondaryButton: .cancel())
		}
		.sheet(isPresented: $catsViewModel.isImagePicker) {
			ImagePicker(image: $catsViewModel.catsImage)
		}
	}
}

struct EditingCatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		EditingCatsPageView(catsViewModel: CatsCardsPageViewModel(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), managedObjectContext: PersistenceController.preview.conteiner.viewContext))
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
