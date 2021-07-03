//
//  HomeScreenView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import SwiftUI

struct HomeScreenView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@EnvironmentObject var settingsViewModel: SettingsViewModel
	
	@FetchRequest(
		entity: CatsCard.entity(),
		sortDescriptors: [],
		predicate: nil,
		animation: nil
	) var catsCards: FetchedResults<CatsCard>
	
	@StateObject var homeScreenViewModel = HomeScreenViewModel()
	
    var body: some View {
		ZStack {
			Color.mainColor
			
			VStack {
				TopBarView(minHeight: 80, maxHeight: 80, trailing: {
					Button(action: {
						homeScreenViewModel.makeNewCat(context: managedObjectContext)
						
					}, label: {
						Image3D(
							topView: Image(systemName: "plus"),
							bottomView: Image(systemName: "plus"),
							topColor: .volumeEffectColorTop,
							bottomColor: .volumeEffectColorBottom
						)
						.equatable()
					})
					.frame(width: 60, height: 60)
					.buttonStyle(CircleButtonStyle())
					.padding()
				})
				
				Spacer()
				
				ScrollView(.vertical, showsIndicators: false) {
					ForEach(catsCards) { card in
						CatsCardView(cat: card)
							.equatable()
							.overlay(
								HStack {
									ZStack {
										Color.black.opacity(0.001)
										
										Spacer()
									}
									.simultaneousGesture(
										TapGesture()
											.onEnded { _ in
												homeScreenViewModel.selectCat(card)
												homeScreenViewModel.observeCat(context: managedObjectContext)
											}
									)
									
									HStack(spacing: 5) {
										ForEach(0..<3) { circle in
											Circle()
												.frame(width: 10, height: 10)
										}
									}
									.padding(.trailing)
									.onTapGesture {
										homeScreenViewModel.selectCat(card)
										
										homeScreenViewModel.changeCatsColor()
									}
									.foregroundColor(.accentColor)
								}
							)
							.padding([.leading, .top, .trailing])
						
						Spacer(minLength: 10)
					}
				}
			}
			.fullScreenCover(isPresented: $homeScreenViewModel.isMainCatsPageView) {
				homeScreenViewModel.mainCatsPageView
					.preferredColorScheme(settingsViewModel.wrappedColorScheme)
					.onDisappear {
						homeScreenViewModel.mainCatsPageView = nil
						homeScreenViewModel.deselectCat()
					}
			}
			.sheet(isPresented: $homeScreenViewModel.isAddCatSheet) {
				homeScreenViewModel.editingCatsPageView
					.preferredColorScheme(settingsViewModel.wrappedColorScheme)
					.onDisappear {
						homeScreenViewModel.editingCatsPageView = nil
					}
			}
			.animation(.easeInOut(duration: 0.2).delay(0.41))
			.blur(radius: homeScreenViewModel.isColorPicker ? 20 : 0)
			.disabled(homeScreenViewModel.isColorPicker)
			
			if homeScreenViewModel.isColorPicker {
				ZStack {
					homeScreenViewModel.catsCardsColorPicker
						.preferredColorScheme(settingsViewModel.wrappedColorScheme)
				}
				.animation(.linear(duration: 0.4))
				.transition(.move(edge: .bottom))
				.onDisappear {
					let isChanges = homeScreenViewModel.catsCardsColor.compareColorComponentsWith(
						homeScreenViewModel.catsCardsColorPicker.pickedColor
					)
					homeScreenViewModel.saveChangesIf(!isChanges, context: managedObjectContext)
					
					homeScreenViewModel.deselectCat()
					homeScreenViewModel.catsCardsColorPicker = nil
				}
			}
		}
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
