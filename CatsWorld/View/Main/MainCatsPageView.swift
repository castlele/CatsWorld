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
	
	@State var ageType: AgeType = .age
	
	@ObservedObject var catsDescriptionViewModel: CatsDescriptionViewModel
	
	@State var isEditingCatsPage = false
	
	var body: some View {
		VStack {
			ZStack {
				Rectangle()
					.fill(Color.black.opacity(0.5))
					.blur(radius: 2)
					.offset(x: 0, y: 3)
				Rectangle()
					.fill(Color.white)
				
				VStack {
					HStack {
						Button(action: {
							presentationMode.wrappedValue.dismiss()
							
						}, label: {
							Image3D(
								topView: Image(systemName: "xmark"),
								bottomView: Image(systemName: "xmark"),
								topColor: .white,
								bottomColor: Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
							)
						})
						.frame(width: 50, height: 50)
						.buttonStyle(CircleButtonStyle(backGroundColor: Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))))
						.padding()
						
						Spacer()
						
						Button(action: {
							isEditingCatsPage.toggle()
							
						}, label: {
							Image3D(
								topView: Image(systemName: "pencil"),
								bottomView: Image(systemName: "pencil"),
								topColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
								bottomColor: .gray
							)
						})
						.frame(width: 50, height: 50)
						.buttonStyle(CircleButtonStyle())
						.padding()
					}
					CatsMainInfoView(cat: catsDescriptionViewModel.cat, age: $ageType, isGender: true)
						.onTapGesture {
							switch ageType {
								case .age:
									ageType = .dateOfBirth
								case .dateOfBirth:
									ageType = .age
							}
						}
				}
			}
			.ignoresSafeArea(edges: .top)
			.frame(minHeight: 150, maxHeight: 200)
			
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
				
				VStack(alignment: .leading) {
					
						RadarChartView(
							data: catsDescriptionViewModel.friendlyCharacteristics,
							gridColor: .gray,
							dataColor: .green,
							reorder: catsDescriptionViewModel.reorderDataNames(names:)
						)
						.frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth / 2)
						
						.padding()
					
					
					Spacer()
					
					CatsDescriptionSettingsView(settings: catsDescriptionViewModel.settingsFor(category: .physical))
					
					CatsDescriptionSettingsView(settings: catsDescriptionViewModel.settingsFor(category: .psycological))
					
					CatsDescriptionSettingsView(settings: catsDescriptionViewModel.settingsFor(category: .shows))
				}
			}
		}
		.background(Color(catsDescriptionViewModel.cat.wrappedColor).blur(radius: 200))
		.sheet(isPresented: $isEditingCatsPage) {
			EditingCatsPageView(catsViewModel: CatsCardsViewModel(cat: catsDescriptionViewModel.cat, managedObjectContext: managedObjectContext))
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
