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
		VStack(spacing: 0) {
			
			// MARK: - TopBarView
			TopBarView(
				isVolume: catsDescriptionViewModel.isVolumeTopBar,
				backgroundColor: catsDescriptionViewModel.catsCardColor,
				minHeight: 90,
				maxHeight: 90,
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
					.padding(.leading)
					.padding(.bottom, 10)
				
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
				.padding(.trailing)
				.padding(.bottom, 10)
			}
			)
			.overlay(
				HStack(spacing: 15) {
					Spacer(minLength: 50)
					
					CatsAvatar(avatar: catsDescriptionViewModel.getCat().wrappedImage)
						.frame(width: 50, height: 50)
						.padding(.leading)

					CatsMainInfoView(cat: catsDescriptionViewModel.getCat(), ageType: $catsDescriptionViewModel.ageType, isGender: true)
						.frame(width: 90, height: 50)
					
					Spacer(minLength: 50)
				}
				.opacity(catsDescriptionViewModel.isVolumeTopBar ? 1 : 0)
				.animation(.linear)
			)
			.zIndex(2)
					
			// MARK: - ScrollView
			ScrollView(showsIndicators: false) {
				
				// MARK: - Main Info View
				HStack {
					Spacer(minLength: 50)
					
					CatsMainInfoView(cat: catsDescriptionViewModel.getCat(),
									 ageType: $catsDescriptionViewModel.ageType,
									 isGender: true,
									 isAvatar: true)
						.equatable()
						.onTapGesture {
							catsDescriptionViewModel.changeAgeType()
						}
						.opacity(catsDescriptionViewModel.isVolumeTopBar ? 0 : 1)
						.animation(.linear)
					
					Spacer(minLength: 50)
				}
				.padding()
				.frame(height: 100)
				.padding()
				.background(catsDescriptionViewModel.catsCardColor)
				.volumetricShadows(shape: .rect, color1: .clear, radius: 2)
				.padding(.bottom)
				.overlay(
					GeometryReader { geometry -> Color in
						catsDescriptionViewModel
							.transitCatsMainInfoIntoTopBar(geometry.frame(in: .named("SCROLL")).minY)
						
						return .clear
					}
				)
				.zIndex(1)
				
				VStack {
					// MARK: - Additional Section
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
					
					// MARK: - Radar chart Section
					if catsDescriptionViewModel.isChartDataEmpty {
						RadarChartView(
							data: catsDescriptionViewModel.friendlyCharacteristics,
							gridColor: .gray,
							dataColor: .green,
							reorder: catsDescriptionViewModel.reorderDataNames(names:)
						)
						.equatable()
						.frame(width: 200, height: 150)
						.padding()
					}
					
					Spacer()
					
					// MARK: - Main Sections
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
			.coordinateSpace(name: "SCROLL")
			.zIndex(0)
		}
		.onAppear {
			catsDescriptionViewModel.setColorScheme(colorScheme)
			UIScrollView.appearance().bounces = false
		}
		.onDisappear {
			UIScrollView.appearance().bounces = false
		}
		.onChange(of: colorScheme) { newScheme in
			catsDescriptionViewModel.setColorScheme(newScheme)
		}
		.background(Color.mainColor.ignoresSafeArea())
		.sheet(isPresented: $catsDescriptionViewModel.isEditingCatsPage) {
			catsDescriptionViewModel.editingCatsPageView
				.preferredColorScheme(colorScheme)
				.onDisappear {
					catsDescriptionViewModel.editingCatsPageView = nil
					catsDescriptionViewModel.dismissIfCatDeleted(presentation: presentationMode)
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
		cat.color = "Flora"
		return cat
	}()
    static var previews: some View {
		MainCatsPageView(catsDescriptionViewModel: CatsDescriptionViewModel(cat: cat, context: PersistenceController.preview.conteiner.viewContext))
    }
}
