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
			TopBarView(minHeight: 150, maxHeight: 200, leading: {
				CancelButton(
					presentation: presentationMode,
					showAlert: .constant(false),
					wasChanges: false,
					content: {
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
				EditButton(isEditing: $catsDescriptionViewModel.isEditingCatsPage) {
					Image3D(
						topView: Image(systemName: "pencil"),
						bottomView: Image(systemName: "pencil"),
						topColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
						bottomColor: .gray
					)
				}
				.frame(width: 50, height: 50)
				.buttonStyle(CircleButtonStyle())
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
					ZStack {
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.white)
							.volumetricShadows(color2: .black, isInner: true)
							.padding()
						
						HStack(alignment: .firstTextBaseline) {
							Text(additionalInfo)
								.lineLimit(.max)
								.padding()
							
						}
						.padding()
					}
					.padding([.leading, .trailing])
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
					.
				}
			}
		}
		.background(Color(catsDescriptionViewModel.cat.wrappedColor).blur(radius: 200))
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
