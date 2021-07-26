//
//  HomeScreenView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import SwiftUI

struct HomeScreenView: View {
	
	@Environment(\.menuWidth) var menuWidth
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@EnvironmentObject var settingsViewModel: SettingsViewModel
	
	@FetchRequest(entity: CatsCard.entity(), sortDescriptors: []) var catsCards: FetchedResults<CatsCard>
	
	@StateObject var homeScreenViewModel = HomeScreenViewModel()
		
    var body: some View {
		ZStack {
			Color.mainColor.zIndex(0)
			
			VStack {
				// MARK: - TopBarView
				TopBarView(
					isVolume: false,
					minHeight: 80,
					maxHeight: 90,
					content: {
						HStack {
							RoundedRectangle(cornerRadius: 20)
								.fill(Color.mainColor)
								.overlay(
									HStack {
										// MARK: - Search Bar View
										SearchBarView(placeholder: "Search placeholder Card", text: $homeScreenViewModel.textToSearch)
											.padding([.top, .bottom, .leading])
										
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
										.padding()
										.rotationEffect(.degrees(homeScreenViewModel.isSortingAssending ? 0 : 180))
										.onLongPressGesture {
											withAnimation(.easeInOut(duration: 0.5)) {
												homeScreenViewModel.isSortingMenu.toggle()
											}
										}
										.simultaneousGesture(
											TapGesture()
												.onEnded {
													withAnimation(.easeInOut(duration: 0.5)) {
														homeScreenViewModel.isSortingAssending.toggle()
													}
												}
										)
									}
								)
								.frame(height: 50)
								.volumetricShadows()
								.padding()
							
							Spacer()
							
							
							// MARK: - Make New Cat
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

					// MARK: - CatCards
					CoreDataEntityFetcher(
						sortingDescriptor: NSSortDescriptor(key: homeScreenViewModel.sortingKey, ascending: homeScreenViewModel.isSortingAssending),
						filter: homeScreenViewModel.validateCatsCards(cat:)
					) { (card: CatsCard)  in
						
						CatsCardView(cat: card)
							.equatable()
							.volumetricShadows()
							.overlay(
								HStack {
									ZStack {
										Color.black.opacity(0.001)
									}
									.simultaneousGesture(
										TapGesture()
											.onEnded { _ in
												if homeScreenViewModel.isSelectedMode {
													homeScreenViewModel.doOnSelect(cat: card)

												} else {
													homeScreenViewModel.selectCat(card)
													homeScreenViewModel.observeCat(context: managedObjectContext)
												}
											}
									)
									.onLongPressGesture { homeScreenViewModel.toggleSelectionMode() }
									
									HStack(spacing: 5) {
										ForEach(0..<3) { circle in
											Circle()
												.frame(width: 10, height: 10)
										}
									}
									.padding(.trailing)
									.overlay(
										RoundedRectangle(cornerRadius: 20)
											.fill(Color.green)
											.overlay(
												Image(systemName: "checkmark")
													.foregroundColor(.white)
													.padding()
											)
											.scaledToFill()
											.opacity(homeScreenViewModel.isCatSelected(cat: card))
									)
									.simultaneousGesture(
										TapGesture()
											.onEnded { _ in
												if !homeScreenViewModel.isSelectedMode {
													homeScreenViewModel.selectCat(card)
													homeScreenViewModel.isMenu.toggle()
												} else {
													homeScreenViewModel.doOnSelect(cat: card)
												}
											}
									)
									.foregroundColor(.accentColor)
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
			// MARK: - MainCatsPageView
			.fullScreenCover(isPresented: $homeScreenViewModel.isMainCatsPageView) {
				homeScreenViewModel.mainCatsPageView
					.preferredColorScheme(settingsViewModel.wrappedColorScheme)
					.onDisappear {
						homeScreenViewModel.mainCatsPageView = nil
						homeScreenViewModel.deselectCat()
					}
			}
			// MARK: - EditionCatsPageView
			.sheet(isPresented: $homeScreenViewModel.isEditingCatsSheet) {
				homeScreenViewModel.editingCatsPageView
					.preferredColorScheme(settingsViewModel.wrappedColorScheme)
					.onDisappear {
						homeScreenViewModel.editingCatsPageView = nil
					}
			}
			.blur(radius: homeScreenViewModel.isColorPicker ? 10 : 0)
			.disabled(homeScreenViewModel.isColorPicker || homeScreenViewModel.isMenu || homeScreenViewModel.isSortingMenu)
//			.animation(.easeInOut(duration: 2).delay(0.41))
			.zIndex(1)
			
			// MARK: - Selected cards
			if homeScreenViewModel.isSelectedMode {
				GeometryReader { geometry in
					
					VStack {
						HStack {
							Spacer()
							
							Button(action: {
								homeScreenViewModel.deleteAllSelectedCats(context: managedObjectContext)
								
							}, label: {
								Text("Delete")
									.standardText(fgColor: .white, style: .body)
									.padding(.horizontal, 5)
							})
							.buttonStyle(OvalButtonStyle(
											backgroundColor: homeScreenViewModel.isSelectedCatsCard ? .red : Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)),
											shadowColor1: .clear
										)
							)
							.padding(.trailing)
							.padding(.bottom, 5)
						}
						
						HStack {
							Button(action: {
								homeScreenViewModel.toggleSelectionMode()
								
							}, label: {
								Text("Cancel")
									.standardText(fgColor: .white, style: .body)
									.padding(.horizontal, 5)
							})
							.buttonStyle(OvalButtonStyle(backgroundColor: Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), shadowColor1: .clear))
							.padding(.leading)
							
							Spacer()
							
							Button(action: {
								homeScreenViewModel.selectAllCats(context: managedObjectContext)
								
							}, label: {
								Text("Select all")
									.standardText(fgColor: .white, style: .body)
									.padding(.horizontal, 5)
							})
							.buttonStyle(OvalButtonStyle(backgroundColor: Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), shadowColor1: .clear))
							.padding(.trailing)
						}
					}
					.frame(width: UIScreen.screenWidth)
					.offset(x: (geometry.size.width - UIScreen.screenWidth) / 2, y: geometry.frame(in: .local).maxY - 98)
				}
			}
			
			// MARK: - ColorPicker
			if homeScreenViewModel.isColorPicker {
				ZStack {
					homeScreenViewModel.catsCardsColorPicker
						.preferredColorScheme(settingsViewModel.wrappedColorScheme)
				}
				.background(
					RoundedRectangle(cornerRadius: 20)
						.stroke(Color.shadowColor)
				)
				.animation(.linear(duration: 0.4))
				.transition(.move(edge: .bottom))
				.onDisappear {
					homeScreenViewModel.saveChanges(context: managedObjectContext)
					
					homeScreenViewModel.deselectCat()
					homeScreenViewModel.catsCardsColorPicker = nil
					homeScreenViewModel.resetChanges()
				}
			}
			
			// MARK: - Sorting MenuView
			if homeScreenViewModel.isSortingMenu {
				GeometryReader { geometry in
					CatsDescriptionSection {
						Button("Sort by names") {
							
							withAnimation(.easeInOut(duration: 0.5)) {
								homeScreenViewModel.sortingKey = "name"
								homeScreenViewModel.isSortingMenu.toggle()
							}
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.primary)
						
						Button("Sort by age") {
							
							withAnimation(.easeInOut(duration: 0.5)) {
								homeScreenViewModel.sortingKey = "dateOfBirth"
								homeScreenViewModel.isSortingMenu.toggle()
							}
						}
						.font(.system(.body, design: .rounded))
						.frame(minWidth: menuWidth, maxWidth: menuWidth + 20)
						.foregroundColor(.primary)
					}
					.volumetricShadows(color1: .clear, color2: .shadowColor)
					.frame(minWidth: menuWidth, maxWidth: menuWidth, minHeight: 100, maxHeight: 100)
					.offset(x: (geometry.size.width - menuWidth) / 2, y: geometry.frame(in: .local).maxY - 112)
				}
				.menuTransition()
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
							withAnimation(.linear(duration: 0.4)) {
								homeScreenViewModel.isMenu.toggle()
							}
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
					.volumetricShadows(color1: .clear, color2: .shadowColor)
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
