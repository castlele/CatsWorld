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
			TopBarView(minHeight: 100, maxHeight: 100, leading: {
				CancelButton(
					showAlert: $catsViewModel.isAlertShown,
					wasChanges: catsViewModel.wasChanged,
					action: {
						catsViewModel.dismiss(presentation: presentation)
					}, content: {
						XButton()
					})
					.frame(width: 50, height: 50)
					.buttonStyle(CircleButtonStyle(backgroundColor: Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))))
					.padding([.top, .leading])
				
			}, trailing: {
				DoneButton(action: {
					catsViewModel.dismiss(isDiscardChanges: false, presentation: presentation)
					
				}, content: {
					View3D(
						topView:  PawView().scale(0.8),
						bottomView:  PawView().scale(0.8),
						topColor: .volumeEffectColorTop,
						bottomColor: .volumeEffectColorBottom	
					)
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
				CatsDescriptionSection() {
					TextField("Name", text: $catsViewModel.name)
						.disableAutocorrection(true)
						.accentColor(.mainColor)
					
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
				.foregroundColor(.textColor)
				.accentColor(.accentColor)
				
				// MARK:- Physical section
				CatsDescriptionSection() {
					HStack {
						Text("Weight \(catsViewModel.weight, specifier: "%.1f") kg")

						Spacer()

						Slider(value: $catsViewModel.weight, in: 0...50)
					}

					Group {
						Toggle("Is castrated", isOn: $catsViewModel.isCastrated)
						
						Toggle("Is the tail suppressed", isOn: $catsViewModel.suppressedTail)
						
						Toggle("Is the legs are short", isOn: $catsViewModel.shortLegs)
						
						Toggle("Is hair less", isOn: $catsViewModel.hairless)
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))
				}
				.foregroundColor(.textColor)
				.accentColor(.accentColor)
				
				// MARK:- Psycological section
				CatsDescriptionSection() {
					Picker("Temperament", selection: $catsViewModel.temperament) {
						ForEach(Temperament.allCases, id: \.self) { temperament in
							Text("\(temperament.rawValue.capitalized)")
								.foregroundColor(.textColor)
								.fontWeight(.ultraLight)
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
				.accentColor(.accentColor)
				
				// MARK:- More info section
				CatsDescriptionSection() {
					VStack {
						if catsViewModel.additionalInfo.isEmpty {
							Text("Write whatever you want about your cat").foregroundColor(.textColor)
						}
						
						TextEditor(text: $catsViewModel.additionalInfo)
							.disableAutocorrection(true)
							.foregroundColor(.textColor)
							.background(Color.mainColor)
							.accentColor(.accentColor)
					}
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
		.background(Color.mainColor)
	}
}

struct EditingCatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		EditingCatsPageView(catsViewModel: CatsCardsPageViewModel(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), managedObjectContext: PersistenceController.preview.conteiner.viewContext))
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
