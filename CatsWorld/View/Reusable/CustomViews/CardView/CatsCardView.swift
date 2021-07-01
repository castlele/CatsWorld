//
//  CatsCardView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//

import SwiftUI

struct CatsCardView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@ObservedObject var cat: CatsCard
	@Binding var isColorPicker: Bool
	@StateObject var catsCardsViewModel = CatsCardsViewModel()
	
	var cardColor: Color {
		let uiColor = cat.wrappedColor
		return Color(uiColor)
	}
	
    var body: some View {
		HStack {
			CatsAvatar(avatar: cat.wrappedImage)
				.background(
					Circle()
						.stroke(Color.accentColor, lineWidth: 4)
				)
				.frame(minWidth: 50, minHeight: 50, maxHeight: 100)
				.padding(.trailing, 10)
			
			CatsMainInfoView(cat: cat, age: .constant(.age))
			
			GenderSign(genderSign: cat.genderSign, foregroundColor: .textColor)
				.frame(maxWidth: 40)
				
			Spacer(minLength: 50)
		}
		.simultaneousGesture(
			TapGesture()
				.onEnded { _ in
					catsCardsViewModel.isCatsPageView.toggle()
				}
		)
		.fullScreenCover(isPresented: $catsCardsViewModel.isCatsPageView) {
			CatsPageView(cat: cat)
		}
//		.sheet(isPresented: $catsCardsViewModel.isEditingCatsPage) {
//			CatsPageView(cat: cat, isEditing: true)
//		}
		.padding()
		.frame(minHeight: 100)
		.background(cardColor)
		.clipShape(RoundedRectangle(cornerRadius: 20))
		.volumetricShadows()
	}
}

struct CatsCardView_Previews: PreviewProvider {
	static var cat: CatsCard = {
		let cat = CatsCard(context: PersistenceController.preview.conteiner.viewContext)
		cat.name = "Long Long Name"
		cat.breed = "Шоколадный Йорк"
		return cat
	}()
	
    static var previews: some View {
		CatsCardView(cat: cat, isColorPicker: .constant(false))
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
				}
			)
			.padding([.leading, .trailing])
    }
}
