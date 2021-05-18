//
//  CatsCardView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//

import SwiftUI

struct CatsCardView: View {
	
	var cat: CatsCard
	
	var cardColor: Color {
		let uiColor = cat.wrappedColor
		return Color(uiColor)
	}
	
    var body: some View {
		GeometryReader { geometry in
			HStack {
				CatsMainInfoView(cat: cat)
				
				Spacer()
				
				HStack(spacing: 5) {
					ForEach(0..<3) { circle in
						Circle()
							.frame(width: 10, height: 10)
					}
				}
			}
			.padding()
			.frame(minWidth: geometry.size.width, minHeight: geometry.size.width / 2)
			.background(cardColor)
			.clipShape(RoundedRectangle(cornerRadius: 20))
		}
    }
}

struct CatsCardView_Previews: PreviewProvider {
    static var previews: some View {
		CatsPageView(cat: CatsCard(context: PersistenceController.shared.conteiner.viewContext))
    }
}
