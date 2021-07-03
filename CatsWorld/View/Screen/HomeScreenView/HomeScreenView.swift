//
//  HomeScreenView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import SwiftUI

struct HomeScreenView: View {
	
	private let viewWidth = UIScreen.screenWidth / 1.2
	private let viewHeight = UIScreen.screenHeight / 1.5
	private let minViewHeight = UIScreen.screenHeight / 1.75
	
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
								VStack {
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
											homeScreenViewModel.isMenu.toggle()
										}
										.foregroundColor(.accentColor)
									}
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
			.sheet(isPresented: $homeScreenViewModel.isEditingCatsSheet) {
				homeScreenViewModel.editingCatsPageView
					.preferredColorScheme(settingsViewModel.wrappedColorScheme)
					.onDisappear {
						homeScreenViewModel.editingCatsPageView = nil
					}
			}
			.animation(.easeInOut(duration: 0.2).delay(0.41))
			.blur(radius: homeScreenViewModel.isColorPicker ? 20 : 0)
			.disabled(homeScreenViewModel.isColorPicker || homeScreenViewModel.isMenu)
			
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
			
			if homeScreenViewModel.isMenu {
				CatsDescriptionSection {
					Button("Delete") {
						homeScreenViewModel.deleteCat(context: managedObjectContext)
//						managedObjectContext.delete(homeScreenViewModel.getCat())
//
//						withAnimation() {
//							homeScreenViewModel.isMenu.toggle()
//						}
					}
					.frame(minWidth: viewWidth, maxWidth: viewWidth + 20)
					.foregroundColor(.red)

					Button("Edit") {
						homeScreenViewModel.editCat(context: managedObjectContext)
					}
					.frame(minWidth: viewWidth, maxWidth: viewWidth + 20)
					.foregroundColor(.accentColor)

					Button("Pick Cards Color") {
						homeScreenViewModel.changeCatsColor()
					}
					.frame(minWidth: viewWidth, maxWidth: viewWidth + 20)
					.foregroundColor(.accentColor)

					Button("Cancel") {
						withAnimation(.linear(duration: 0.4)) {
							homeScreenViewModel.isMenu.toggle()
						}
					}
					.frame(minWidth: viewWidth, maxWidth: viewWidth + 20)
					.foregroundColor(.accentColor)
				}
				.shadow(color: .shadowColor, radius: 7, x: 7, y: 7)
				.animation(.linear(duration: 0.4))
				.transition(.move(edge: .bottom))
				.frame(minWidth: viewWidth, maxWidth: viewWidth + 20, minHeight: 100, maxHeight: 100)
				.offset(y: UIScreen.screenHeight / 2 - 150)
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
