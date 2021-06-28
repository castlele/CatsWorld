//
//  MainCatsPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct MainCatsPageView: View {
	
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@ObservedObject var catsDescriptionViewModel: CatsDescriptionViewModel
	
	var body: some View {
		VStack {
			TopBarView(
				backgroundColor: Color(catsDescriptionViewModel.cat.wrappedColor),
				minHeight: 150,
				maxHeight: 200,
				leading: {
				CancelButton(
					presentation: presentationMode,
					showAlert: .constant(false),
					wasChanges: false,
					content: {
						XButton()
					})
					.frame(width: 50, height: 50)
					.buttonStyle(
						CircleButtonStyle(
							backgroundColor: Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)),
							shadowColor1: Color(catsDescriptionViewModel.catsCardColor).lighter(by: 0.1),
							shadowColor2: Color(catsDescriptionViewModel.catsCardColor).darker(by: 0.5)
						)
					)
					.padding([.top, .leading])
				
				
			}, trailing: {
				EditButton(isEditing: $catsDescriptionViewModel.isEditingCatsPage) {
					Image3D(
						topView: Image(systemName: "pencil"),
						bottomView: Image(systemName: "pencil"),
						topColor: .volumeEffectColorTop,
						bottomColor: .volumeEffectColorBottom
					)
				}
				.frame(width: 50, height: 50)
				.buttonStyle(
					CircleButtonStyle(
						shadowColor1: Color(catsDescriptionViewModel.catsCardColor).lighter(by: 0.1),
						shadowColor2: Color(catsDescriptionViewModel.catsCardColor).darker(by: 0.5)
					)
				)
				.padding([.top, .trailing])
				
			}, content: {
				CatsMainInfoView(cat: catsDescriptionViewModel.cat, age: $catsDescriptionViewModel.ageType, isGender: true)
					.padding(.bottom)
					.onTapGesture {
						switch catsDescriptionViewModel.ageType {
							case .age:
								catsDescriptionViewModel.ageType = .dateOfBirth
							case .dateOfBirth:
								catsDescriptionViewModel.ageType = .age
						}
					}
			})
			
			Spacer()
			
			ScrollView {
				if let additionalInfo = catsDescriptionViewModel.cat.additionalInfo, !additionalInfo.isEmpty {
					CatsDescriptionSection() {
						HStack(alignment: .firstTextBaseline) {
							Text(additionalInfo)
								.lineLimit(.max)
								.padding()
								.foregroundColor(.textColor)
							
						}
						.padding(.bottom)
					}
					.volumetricShadows()
				}
				
				VStack {
					RadarChartView(
						data: catsDescriptionViewModel.friendlyCharacteristics,
						gridColor: .gray,
						dataColor: .green,
						reorder: catsDescriptionViewModel.reorderDataNames(names:)
					)
					.frame(width: 200, height: 150)
					.padding()
					
					Spacer()
					
					Group {
						CatsDescriptionSection() {
							CatsDescriptionSettingsView(settings: catsDescriptionViewModel.settingsFor(category: .physical))
						}
						
						CatsDescriptionSection() {
							CatsDescriptionSettingsView(settings: catsDescriptionViewModel.settingsFor(category: .psycological))
						}
						
						CatsDescriptionSection() {
							CatsDescriptionSettingsView(settings: catsDescriptionViewModel.settingsFor(category: .shows))
						}
					}
					.volumetricShadows()
					.foregroundColor(.textColor)
				}
			}
		}
		.background(Color.mainColor)
		.sheet(isPresented: $catsDescriptionViewModel.isEditingCatsPage) {
			EditingCatsPageView(catsViewModel: CatsCardsPageViewModel(cat: catsDescriptionViewModel.cat, managedObjectContext: managedObjectContext))
		}
	}
}

struct MainCatsPageView_Previews: PreviewProvider {
	static var cat: CatsCard = {
		let cat = CatsCard(context: PersistenceController.preview.conteiner.viewContext)
		cat.childFriendly = 5
		cat.strangerFriendly = 2
		cat.dogFriendly = 3
		return cat
	}()
    static var previews: some View {
		MainCatsPageView(catsDescriptionViewModel: CatsDescriptionViewModel(cat: cat))
    }
}
