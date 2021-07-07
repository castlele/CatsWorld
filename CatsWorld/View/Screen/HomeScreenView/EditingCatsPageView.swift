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
					.equatable()
			   })
				.frame(width: 50, height: 50)
				.buttonStyle(CircleButtonStyle())
				.padding([.top, .trailing])
			})
			
			ScrollView {
				CatsAvatar(avatar: catsViewModel.catsImage)
					.frame(width: 150, height: 150)
					.background(EarsView())
						.padding([.top, .bottom])
					.simultaneousGesture(
						TapGesture()
							.onEnded { _ in
								catsViewModel.isImagePicker.toggle()
							}
					)
				
				// MARK:- Main info section
				CatsDescriptionSection() {
					TextField("Name", text: $catsViewModel.name)
						.frame(minWidth: 150, maxWidth: UIScreen.screenWidth)
						.disableAutocorrection(true)
						.accentColor(.accentColor)
					
					DatePicker(
						"Date of birth".localize(),
						selection: $catsViewModel.dateOfBirth, in: ...Date(),
						displayedComponents: .date
					)
					.datePickerStyle(DefaultDatePickerStyle())
					
					Picker("What is the cats's gender", selection: $catsViewModel.gender) {
						ForEach(0..<2) { index in
							Text("\(Gender.allCases[index].rawValue.localize().capitalized)").tag(Gender.allCases[index])
						}
					}
					.pickerStyle(SegmentedPickerStyle())
					
					Picker("Breed of the cat", selection: $catsViewModel.breed) {
						ForEach(BreedsViewModel.shared.breeds, id: \.name) { breed in
							Text(breed.name.localize())
						}
					}
					.pickerStyle(InlinePickerStyle())
				}
				.volumetricShadows()
				.sectionPadding()
				.foregroundColor(.textColor)
				.accentColor(.accentColor)
				
				// MARK:- Physical section
				CatsDescriptionSection() {
					HStack {
						Text("Weight \(catsViewModel.weight, specifier: "%.1f") kg")

						Spacer()

						Stepper("Weight stepper", value: $catsViewModel.weight, in: 0...50, step: 0.1)
							.labelsHidden()
					}

					Group {
						Toggle("Is castrated", isOn: $catsViewModel.isCastrated)
						
						Toggle("Is the tail suppressed", isOn: $catsViewModel.suppressedTail)
						
						Toggle("Is the legs are short", isOn: $catsViewModel.shortLegs)
						
						Toggle("Is hair less", isOn: $catsViewModel.hairless)
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))
				}
				.volumetricShadows()
				.sectionPadding()
				.foregroundColor(.textColor)
				.accentColor(.accentColor)
				
				// MARK:- Psycological section
				CatsDescriptionSection() {
					Picker("Temperament", selection: $catsViewModel.temperament) {
						ForEach(Temperament.allCases, id: \.self) { temperament in
							Text("\(temperament.rawValue.localize().capitalized)")
								.foregroundColor(.textColor)
								.fontWeight(.ultraLight)
						}
					}
					.pickerStyle(SegmentedPickerStyle())

					RatingView(rating: $catsViewModel.strangerFriendly,
							   label: "Stranger friendly".localize(),
							   offImage: Image(systemName: "star"),
							   onImage: Image(systemName: "star.fill")
					)

					RatingView(rating: $catsViewModel.childFriendly,
							   label: "Child friendly".localize(),
							   offImage: Image(systemName: "star"),
							   onImage: Image(systemName: "star.fill")
					)

					RatingView(rating: $catsViewModel.dogFriendly,
							   label: "Dog friendly".localize(),
							   offImage: Image(systemName: "star"),
							   onImage: Image(systemName: "star.fill")
					)
				}
				.volumetricShadows()
				.sectionPadding()
				.accentColor(.accentColor)
				
				// MARK:- Additional info section
				CatsDescriptionSection() {
					VStack {
						if catsViewModel.additionalInfo.isEmpty {
							Text("Additional info")
								.foregroundColor(.textColor)
								.lineLimit(3)
						}
						
						TextEditor(text: $catsViewModel.additionalInfo)
							.disableAutocorrection(true)
							.foregroundColor(.textColor)
							.background(Color.mainColor)
							.accentColor(.accentColor)
					}
				}
				.volumetricShadows()
				.sectionPadding()
			}
			.frame(width: UIScreen.screenWidth)
		}
		.alert(isPresented: $catsViewModel.isAlertShown) {
			// TODO:- Redo Alert with Error handling
			Alert(
				title: Text("Discarding changes"),
				message: Text("Sure wanna discard"),
				primaryButton: .default(Text("Discard"), action: { catsViewModel.dismiss(presentation: presentation) }),
				secondaryButton: .cancel()
			)
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
