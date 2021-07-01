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
		animation: .spring()
	) var catsCards: FetchedResults<CatsCard>
	
	@StateObject var homeScreenViewModel = HomeScreenViewModel()
	
    var body: some View {
		ZStack {
			Color.mainColor
			
			VStack {
				TopBarView(minHeight: 80, maxHeight: 80, trailing: {
					Button(action: {
						let cat = CatsCard(context: managedObjectContext)
						homeScreenViewModel.catsPageView = CatsPageView(cat: cat, deleteAfterCancelation: true, isEditing: true)
						homeScreenViewModel.addCatSheet.toggle()
						
					}, label: {
						Image3D(
							topView: Image(systemName: "plus"),
							bottomView: Image(systemName: "plus"),
							topColor: .volumeEffectColorTop,
							bottomColor: .volumeEffectColorBottom
						)
					})
					.frame(width: 60, height: 60)
					.buttonStyle(CircleButtonStyle())
					.padding()
				})
				
				Spacer()
				
				GeometryReader { geometry in
					ScrollView(.vertical, showsIndicators: false) {
						ForEach(catsCards) { card in
							CatsCardView(cat: card, homeScreenViewModel: homeScreenViewModel)
								.overlay(
									HStack {
										Spacer()
										
										HStack(spacing: 5) {
											ForEach(0..<3) { circle in
												Circle()
													.frame(width: 10, height: 10)
											}
										}
										.padding(.trailing)
										.onTapGesture {
											homeScreenViewModel.selectCat(card)
											
											withAnimation(.linear(duration: 1.2)) {
												homeScreenViewModel.isColorPicker.toggle()
											}
										}
										.foregroundColor(.accentColor)
									}
								)
								.padding([.leading, .top, .trailing])
							
							Spacer(minLength: 10)
						}
					}
				}
			}
			.fullScreenCover(isPresented: $homeScreenViewModel.isCatsPageView) {
				CatsPageView(cat: homeScreenViewModel.selectedCat)
			}
			.sheet(isPresented: $homeScreenViewModel.addCatSheet) {
				homeScreenViewModel.catsPageView
			}
			.animation(.spring().delay(1.2))
			.blur(radius: homeScreenViewModel.isColorPicker ? 20 : 0)
			.disabled(homeScreenViewModel.isColorPicker)
			
			if homeScreenViewModel.isColorPicker {
				CatsCardsColorPicker(
					cat: homeScreenViewModel.selectedCat,
					pickedColor: homeScreenViewModel.catsCardsColor,
					isColorPicker: $homeScreenViewModel.isColorPicker
				)
				.animation(.easeInOut(duration: 1.2))
				.transition(.move(edge: .bottom))
				.onDisappear {
					DispatchQueue.global().async {
						do {
							try managedObjectContext.save()
						} catch {
							#if DEBUG
							print("\(error.localizedDescription)")
							#endif
						}
					}
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
