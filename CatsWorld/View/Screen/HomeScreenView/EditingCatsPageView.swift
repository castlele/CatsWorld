//
//  EditingCatsPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import SwiftUI
import CoreData

struct EditingCatsPageView: View {
	
	@Environment(\.menuWidth) var menuWidth
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode
	
	@StateObject var catsViewModel: CatsCardsPageViewModel
	
	var body: some View {
		ZStack {
			VStack {
				// MARK: - TopBarView
				TopBarView(minHeight: 100, maxHeight: 100, leading: {
					CancelButton(
						showAlert: $catsViewModel.isAlertShown,
						alertSettingAction: { catsViewModel.makeAlert(type: .cancel, presentation: presentationMode) },
						wasChanges: catsViewModel.wasChanged,
						action: {
							catsViewModel.dismiss(presentation: presentationMode)
						}, content: {
							XButton()
						})
						.frame(width: 50, height: 50)
						.buttonStyle(CircleButtonStyle(backgroundColor: Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))))
						.padding([.top, .leading])
					
				}, trailing: {
					DoneButton(action: {
						catsViewModel.dismiss(isDiscardChanges: false, presentation: presentationMode)
						
					}, content: {
						Image3D(
							topView: Image(systemName: "checkmark"),
							bottomView: Image(systemName: "checkmark"),
							topColor: .volumeEffectColorTop,
							bottomColor: .volumeEffectColorBottom	
						)
						.equatable()
					})
					.frame(width: 50, height: 50)
					.buttonStyle(CircleButtonStyle())
					.padding([.top, .trailing])
				})
				
				// MARK: - ScrollView
				ScrollView {
					CatsAvatar(avatar: catsViewModel.catsImage ?? UIImage(systemName: "person.crop.circle.fill")!)
						.frame(width: 150, height: 150)
						.overlay(
							VStack {
								Spacer()
								
								ZStack {
									Color.black.opacity(0.4)
									
									Text("Add image")
										.font(.system(size: 13, weight: .medium, design: .rounded))
										.lineLimit(1)
										.allowsTightening(true)
										.foregroundColor(.white)
										.padding([.bottom, .leading, .trailing])
								}
								.frame(height: 40)
							}
						)
						.clipShape(Circle())
						.background(
							ZStack {
								EarsView()
								
								Circle()
									.stroke(Color.accentColor, lineWidth: 4)
							}
						)
						.padding([.top, .bottom])
						.simultaneousGesture(
							TapGesture()
								.onEnded { _ in
									catsViewModel.isImagePickerStyle.toggle()
								}
						)
					
					// MARK:- Main info section
					CatsDescriptionSection() {
						TextField("Name", text: $catsViewModel.name)
							.frame(minWidth: 150, maxWidth: UIScreen.screenWidth)
							.disableAutocorrection(true)
							.accentColor(.accentColor)
							.font(.system(.body, design: .rounded))
						
						DatePicker(
							"Date of birth".localize(),
							selection: $catsViewModel.dateOfBirth, in: ...Date(),
							displayedComponents: .date
						)
						.datePickerStyle(DefaultDatePickerStyle())
						.font(.system(.body, design: .rounded))
						
						Picker("What is the cats's gender", selection: $catsViewModel.gender) {
							ForEach(0..<2) { index in
								Text("\(Gender.allCases[index].rawValue.localize().capitalized)").tag(Gender.allCases[index])
									.font(.system(.body, design: .rounded))
							}
						}
						.pickerStyle(SegmentedPickerStyle())
						
						Picker("Breed of the cat", selection: $catsViewModel.breed) {
							ForEach(BreedsViewModel.shared.breeds, id: \.name) { breed in
								Text(breed.name.localize())
									.font(.system(.body, design: .rounded))
							}
						}
						.pickerStyle(InlinePickerStyle())
					}
					.volumetricShadows()
					.sectionPadding()
					.accentColor(.accentColor)
					
					// MARK:- Physical section
					CatsDescriptionSection() {
						HStack {
							Text("Weight \(catsViewModel.weight, specifier: "%.1f") kg")
								.font(.system(.body, design: .rounded))
							
							Spacer()
							
							Stepper("Weight stepper", value: $catsViewModel.weight, in: 0...50, step: 0.1)
								.labelsHidden()
								.font(.system(.body, design: .rounded))
						}
						
						Group {
							Toggle("Is castrated", isOn: $catsViewModel.isCastrated)
								.font(.system(.body, design: .rounded))
							
							Toggle("Is the tail suppressed", isOn: $catsViewModel.suppressedTail)
								.font(.system(.body, design: .rounded))
							
							Toggle("Is the legs are short", isOn: $catsViewModel.shortLegs)
								.font(.system(.body, design: .rounded))
							
							Toggle("Is hair less", isOn: $catsViewModel.hairless)
								.font(.system(.body, design: .rounded))
						}
						.toggleStyle(SwitchToggleStyle(tint: .accentColor))
					}
					.volumetricShadows()
					.sectionPadding()
					.accentColor(.accentColor)
					
					// MARK:- Psycological section
					CatsDescriptionSection {
						if !catsViewModel.character.isEmpty {
							ScrollView(.horizontal, showsIndicators: false) {
								HStack(spacing: catsViewModel.isOnDeleteCharacter ? 12 : 5) {
									ForEach(catsViewModel.character, id: \.self) { character in
										CollectionElementView(text: character)
											.overlay(
												GeometryReader { geometry in
													Button(action: {
														catsViewModel.character.removeAllOccurances(character)
														
													}, label: {
														Image(systemName: "xmark")
															.resizable()
															.foregroundColor(.white)
															.padding(5)
													})
													.background(Color.red)
													.frame(width: 20, height: 20)
													.clipShape(Circle())
													.offset(x: geometry.frame(in: .local).maxX - 10, y: geometry.frame(in: .local).minY)
													.opacity(catsViewModel.isOnDeleteCharacter ? 1 : 0)
												}
											)
											.simultaneousGesture(
												TapGesture()
													.onEnded {
														withAnimation(.linear) {
															catsViewModel.isOnDeleteCharacter.toggle()
														}
													}
											)
									}
								}
							}
							.cornerRadius(20)
						}
						
						HStack(spacing: 15) {
							TextField("Describe character", text: $catsViewModel.currentCharacter)
								.frame(minWidth: 150, maxWidth: UIScreen.screenWidth)
								.disableAutocorrection(true)
								.accentColor(.accentColor)
								.font(.system(.body, design: .rounded))
							
							if !catsViewModel.currentCharacter.isEmpty {
								Button(action: {
									catsViewModel.currentCharacter = ""
									
								}, label: {
									Image(systemName: "xmark")
										.resizable()
										.foregroundColor(.white)
										.padding(10)
								})
								.frame(width: 34, height: 35)
								.buttonStyle(CircleButtonStyle(backgroundColor: .red))
								
								Button(action: {
									catsViewModel.character.append(catsViewModel.currentCharacter.trimmingCharacters(in: .whitespaces))
									catsViewModel.currentCharacter = ""
									
									UIApplication.shared.endEditing(true)
									
								}, label: {
									Image(systemName: "checkmark")
										.resizable()
										.foregroundColor(.white)
										.padding(10)
								})
								.frame(width: 34, height: 35)
								.buttonStyle(CircleButtonStyle(backgroundColor: .green))
							}
						}
						
						HStack {
							Text("Temperament")
								.font(.system(.body, design: .rounded))
							
							Spacer()
							
							Picker("\(catsViewModel.temperament.rawValue.localize().capitalized)", selection: $catsViewModel.temperament) {
								ForEach(Temperament.allCases, id: \.self) { temperament in
									Text("\(temperament.rawValue.localize().capitalized)")
										.font(.system(.body, design: .rounded))
								}
							}
							.labelsHidden()
							.pickerStyle(MenuPickerStyle())
						}
						
						RatingView(rating: $catsViewModel.strangerFriendly,
								   label: "Stranger Friendly".localize(),
								   offImage: Image(systemName: "star"),
								   onImage: Image(systemName: "star.fill")
						)
						.font(.system(.body, design: .rounded))
						
						RatingView(rating: $catsViewModel.childFriendly,
								   label: "Child Friendly".localize(),
								   offImage: Image(systemName: "star"),
								   onImage: Image(systemName: "star.fill")
						)
						.font(.system(.body, design: .rounded))
						
						RatingView(rating: $catsViewModel.dogFriendly,
								   label: "Dog Friendly".localize(),
								   offImage: Image(systemName: "star"),
								   onImage: Image(systemName: "star.fill")
						)
						.font(.system(.body, design: .rounded))
					}
					.volumetricShadows()
					.sectionPadding()
					.accentColor(.accentColor)
					
					// MARK:- Additional info section
					CatsDescriptionSection() {
						VStack {
							if catsViewModel.additionalInfo.isEmpty {
								Text("Additional info")
									.lineLimit(3)
									.allowsTightening(true)
									.font(.system(.body, design: .rounded))
							}
							
							TextEditor(text: $catsViewModel.additionalInfo)
								.background(
									RoundedRectangle(cornerRadius: 10)
										.stroke(Color.semiAccentColor)
								)
								.disableAutocorrection(true)
								.background(Color.mainColor)
								.accentColor(.accentColor)
								.font(.system(.body, design: .rounded))
						}
					}
					.volumetricShadows()
					.sectionPadding()
					
					Spacer()
					
					// MARK: - Delete button
					Button(action: {
						catsViewModel.makeAlert(type: .delete, presentation: presentationMode)
						catsViewModel.isAlertShown.toggle()
						
					}, label: {
						Text("Delete")
							.bold()
							.standardText()
							.padding(.horizontal, 10)
					})
					.buttonStyle(OvalButtonStyle(backgroundColor: .red))
					.padding([.leading, .trailing, .bottom])
				}
				.frame(width: UIScreen.screenWidth)
			}
			// MARK: - Alert
			.alert(isPresented: $catsViewModel.isAlertShown) {
				// TODO:- Redo Alert with Error handling
				catsViewModel.alertToShow
			}
			// MARK: - Image Picker
			.sheet(isPresented: $catsViewModel.isImagePicker) {
				ImagePicker(pickerSource: catsViewModel.sourceType, image: $catsViewModel.catsImage)
					.preferredColorScheme(colorScheme)
			}
			.background(Color.mainColor.ignoresSafeArea())
			.disabled(catsViewModel.isImagePickerStyle)
			
			// MARK: - ImagePicker Source type
			if catsViewModel.isImagePickerStyle {
				GeometryReader { geometry in
					CatsDescriptionSection {
						Button("Camera") {
							catsViewModel.sourceType = .camera
							
							catsViewModel.isImagePicker.toggle()
							
							catsViewModel.isImagePickerStyle.toggle()
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.primary)
						
						Button("Photo Library") {
							catsViewModel.sourceType = .photoLibrary
							
							catsViewModel.isImagePicker.toggle()
							
							catsViewModel.isImagePickerStyle.toggle()
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.primary)
						
						Button("Cancel") {
							withAnimation(.linear(duration: 0.4)) {
								catsViewModel.isImagePickerStyle.toggle()
							}
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.primary)
					}
					.shadow(color: .shadowColor, radius: 7, x: 7, y: 7)
					.animation(.linear(duration: 0.4))
					.transition(.move(edge: .bottom))
					.frame(minWidth: menuWidth, maxWidth: menuWidth, minHeight: 100, maxHeight: 100)
					.offset(x: (geometry.size.width - menuWidth) / 2, y: geometry.frame(in: .local).maxY - 150)
				}
			}
		}
		.simultaneousGesture(
			TapGesture()
				.onEnded {
					if catsViewModel.isOnDeleteCharacter {
						withAnimation(.linear) {
							catsViewModel.isOnDeleteCharacter.toggle()
						}
					}
					UIApplication.shared.endEditing(true)
				}
		)
	}
}

struct EditingCatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		EditingCatsPageView(catsViewModel: CatsCardsPageViewModel(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), managedObjectContext: PersistenceController.preview.conteiner.viewContext))
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
