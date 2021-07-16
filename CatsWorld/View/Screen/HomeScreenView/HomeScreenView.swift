//
//  HomeScreenView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import SwiftUI

struct HomeScreenView: View {
	
	private let menuWidth = UIScreen.screenWidth / 1.2
	
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.managedObjectContext) var managedObjectContext
	@EnvironmentObject var settingsViewModel: SettingsViewModel
	
	@FetchRequest(
		entity: CatsCard.entity(),
		sortDescriptors: [],
		predicate: nil,
		animation: .spring()
	) var catsCards: FetchedResults<CatsCard>
	
	@StateObject var homeScreenViewModel = HomeScreenViewModel()
		
    var body: some View {
		ZStack {
			Color.mainColor
			
			VStack {
				// MARK: - TopBarView
				TopBarView(
					minHeight: 80,
					maxHeight: 90,
					content: {
						HStack {
							RoundedRectangle(cornerRadius: 20)
								.fill(Color.mainColor)
								.overlay(
									HStack {
										SearchBarView(placeholder: "Search", text: .constant(""))
											.padding([.top, .bottom, .leading])
										
										Button(action: {
											print("sorted")
											
										}, label: {
											Image3D(
												topView: Image(systemName: "line.horizontal.3.decrease.circle"),
												bottomView: Image(systemName: "line.horizontal.3.decrease.circle"),
												topColor: .volumeEffectColorTop,
												bottomColor: .volumeEffectColorBottom,
												isPadding: false
											)
											.equatable()
											.scaleEffect(1.4)
											.aspectRatio(contentMode: .fit)
											
										})
										.padding()
									}
								)
								.frame(height: 50)
								.volumetricShadows()
								.padding()
							
							Spacer()
							
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
							.frame(width: 50, height: 50)
							.buttonStyle(CircleButtonStyle())
							.padding()
						}
						.padding(.bottom)
					})
				
				Spacer()
				
				// MARK: - ScrollView
				ScrollView(.vertical, showsIndicators: false) {
					PullActionView() {
						homeScreenViewModel.makeNewCat(context: managedObjectContext)
						
					} viewToShow: {
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.mainColor)
							.overlay(
								Image3D(
									topView: Image(systemName: "plus"),
									bottomView: Image(systemName: "plus"),
									topColor: .volumeEffectColorTop,
									bottomColor: .volumeEffectColorBottom
								)
								.equatable()
								.frame(width: 50, height: 50)
							)
							.volumetricShadows()
							.padding()
					}
					
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
					
					// MARK: - Zero cat's cards text
					if catsCards.isEmpty {
						VStack {
							Text("Empty CatsCards")
								.font(.system(.body, design: .rounded))
								.multilineTextAlignment(.center)
								.padding([.leading, .trailing, .top])
								.padding(.top, 30)
							
							Spacer()
						}
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
			
			// MARK: - ColorPicker
			if homeScreenViewModel.isColorPicker {
				ZStack {
					homeScreenViewModel.catsCardsColorPicker
						.preferredColorScheme(settingsViewModel.wrappedColorScheme)
				}
				.animation(.linear(duration: 0.4))
				.transition(.move(edge: .bottom))
				.onDisappear {
					homeScreenViewModel.saveChanges(context: managedObjectContext)
					
					homeScreenViewModel.deselectCat()
					homeScreenViewModel.catsCardsColorPicker = nil
					homeScreenViewModel.resetChanges()
				}
			}
			
			// MARK: - MenuView
			if homeScreenViewModel.isMenu {
				GeometryReader { geometry in
					CatsDescriptionSection {
						Button("Delete") {
							homeScreenViewModel.deleteCat(context: managedObjectContext)
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.red)
						
						Button("More info") {
							homeScreenViewModel.observeCat(context: managedObjectContext)
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.primary)
						
						Button("Edit") {
							homeScreenViewModel.editCat(context: managedObjectContext)
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.primary)
						
						Button("Pick Cards Color") {
							homeScreenViewModel.changeCatsColor()
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.primary)
						
						Button("Cancel") {
							withAnimation(.linear(duration: 0.4)) {
								homeScreenViewModel.isMenu.toggle()
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
					.offset(x: (geometry.size.width - menuWidth) / 2, y: geometry.frame(in: .local).maxY - 205)
				}
			}
		}
		.onDisappear {
			homeScreenViewModel.saveChanges(context: managedObjectContext)
		}
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
