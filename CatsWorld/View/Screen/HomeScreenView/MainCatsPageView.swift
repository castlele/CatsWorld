//
//  MainCatsPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct MainCatsPageView: View {
	
	@Environment(\.presentationMode) var presentationMode
	
	@Environment(\.colorScheme) var colorScheme
	
	@StateObject var catsDescriptionViewModel: CatsDescriptionViewModel
	
	var body: some View {
		VStack {
			TopBarView(
				backgroundColor: catsDescriptionViewModel.catsCardColor,
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
					.buttonStyle(
						CircleButtonStyle(
							backgroundColor: Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)),
							shadowColor1: catsDescriptionViewModel.catsCardColor.lighter(by: 0.1),
							shadowColor2: catsDescriptionViewModel.catsCardColor.darker(by: 0.5)
						)
					)
					.padding([.top, .leading])
				
				
			}, trailing: {
				EditButton(action: catsDescriptionViewModel.editCat) {
					Image3D(
						topView: Image(systemName: "pencil"),
						bottomView: Image(systemName: "pencil"),
						topColor: .volumeEffectColorTop,
						bottomColor: .volumeEffectColorBottom
					)
					.equatable()
				}
				.frame(width: 50, height: 50)
				.buttonStyle(
					CircleButtonStyle(
						shadowColor1: catsDescriptionViewModel.catsCardColor.lighter(by: 0.1),
						shadowColor2: catsDescriptionViewModel.catsCardColor.darker(by: 0.5)
					)
				)
				.padding([.top, .trailing])
				
			}, content: {
				CatsMainInfoView(cat: catsDescriptionViewModel.getCat(), ageType: $catsDescriptionViewModel.ageType, isGender: true, isAvatar: true)
					.equatable()
					.frame(maxWidth: 240, alignment: .center)
					.padding(.bottom)
					.onTapGesture {
						catsDescriptionViewModel.changeAgeType()
					}
			})
			
			Spacer()
			
			ScrollView {
				if catsDescriptionViewModel.isAdditionInfo {
					CatsDescriptionSection() {
						HStack(alignment: .firstTextBaseline) {
							Text(catsDescriptionViewModel.additionInfo)
								.lineLimit(.max)
								.padding()
							
						}
						.padding(.bottom)
					}
					.volumetricShadows()
					.sectionPadding()
				}
				
				VStack {
					RadarChartView(
						data: catsDescriptionViewModel.friendlyCharacteristics,
						gridColor: .gray,
						dataColor: .green,
						reorder: catsDescriptionViewModel.reorderDataNames(names:)
					)
					.equatable()
					.frame(width: 200, height: 150)
					.padding()
					
					Spacer()
					
					Group {
						CatsDescriptionSection() {
							CatsDescriptionView(descriptions: catsDescriptionViewModel.getDescriptionsFor(category: .physical))
						}
						
						CatsDescriptionSection() {
							CatsDescriptionView(descriptions: catsDescriptionViewModel.getDescriptionsFor(category: .psycological))
						}
						
						CatsDescriptionSection() {
							CatsDescriptionView(descriptions: catsDescriptionViewModel.getDescriptionsFor(category: .shows))
						}
					}
					.volumetricShadows()
					.sectionPadding()
				}
			}
		}
		.onAppear { catsDescriptionViewModel.setColorScheme(colorScheme) }
		.onDisappear { catsDescriptionViewModel.removeColorScheme() }
		.onChange(of: colorScheme) { newScheme in
			catsDescriptionViewModel.setColorScheme(newScheme)
		}
		.background(Color.mainColor.ignoresSafeArea())
		.sheet(isPresented: $catsDescriptionViewModel.isEditingCatsPage) {
			catsDescriptionViewModel.editingCatsPageView
				.preferredColorScheme(colorScheme)
				.onDisappear {
					catsDescriptionViewModel.editingCatsPageView = nil
				}
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
		MainCatsPageView(catsDescriptionViewModel: CatsDescriptionViewModel(cat: cat, context: PersistenceController.preview.conteiner.viewContext))
    }
}
