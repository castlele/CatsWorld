//
//  CatsCardView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//

import SwiftUI

extension CatsCardView: Equatable {
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.cat.name == rhs.cat.name &&
			lhs.cat.wrappedBreed == rhs.cat.wrappedBreed &&
			lhs.cat.dateOfBirth == rhs.cat.dateOfBirth &&
			lhs.cat.wrappedStringColor == rhs.cat.wrappedStringColor &&
			lhs.cat.image == rhs.cat.image
	}
}

struct CatsCardView: View {
			
	@ObservedObject var cat: CatsCard
	
    var body: some View {
		HStack {
			CatsAvatar(avatar: cat.wrappedImage)
				.background(
					Circle()
						.stroke(Color.accentColor, lineWidth: 4)
				)
				.frame(minWidth: 50, maxWidth: 90, minHeight: 50, maxHeight: 90)
				.padding(.trailing, 10)
			
			CatsMainInfoView(cat: cat, ageType: .constant(.age))
				.equatable()
			
			GenderSign(genderSign: cat.genderSign, foregroundColor: .primary)
				.equatable()
				.frame(maxWidth: 40)
				
			Spacer(minLength: 50)
		}
		.padding()
		.frame(minHeight: 100)
		.background(cat.wrappedColor)
		.clipShape(RoundedRectangle(cornerRadius: 20))
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
		CatsCardView(cat: cat)
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
