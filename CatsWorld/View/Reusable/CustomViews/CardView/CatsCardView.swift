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
		VStack {
			HStack {
				CatsMainInfoView(cat: cat, age: .constant(.age))
				
				GenderSign(genderSign: cat.genderSign, foregroundColor: .textColor)
					
				Spacer(minLength: 50)
			}
			.simultaneousGesture(
				TapGesture()
					.onEnded { _ in
						
							catsCardsViewModel.isCatsPageView.toggle()
						
					}
			)
		}
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
    static var previews: some View {
		CatsCardView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), isColorPicker: .constant(false))
    }
}
