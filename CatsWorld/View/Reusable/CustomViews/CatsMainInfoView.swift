//
//  CatsMainInfoView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsMainInfoView: View {
	
	@ObservedObject var cat: CatsCard
	
	@Binding var age: AgeType
	
	var isGender = false
	
	var wrappedAge: String {
		switch age {
			case .age:
				return cat.age
			case .dateOfBirth:
				return cat.wrappedDateOfBirth
		}
	}
	
	private var strokeColor: Color {
		if isGender {
			return cat.genderColor
		}
		return .gray
	}
	
    var body: some View {
		HStack(spacing: 20) {
			CatsAvatar(avatar: cat.wrappedImage)
				.background(
					Circle()
						.stroke(strokeColor, lineWidth: 4)
				)
				.frame(minWidth: 40, maxWidth: 100, minHeight: 40, maxHeight: 100)
			
			VStack(alignment: .leading, spacing: 2.5) {
				Text("\(cat.wrappedName)")
					.font(.body)
					.fontWeight(.bold)
				Text("\(wrappedAge)")
					.font(.footnote)
				Text("\(cat.wrappedBreed)")
					.font(.subheadline)
					.lineLimit(2)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
    }
}

struct CatsMainInfoView_Previews: PreviewProvider {
	static var previews: some View {
		CatsMainInfoView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), age: .constant(.age))
	}
}
