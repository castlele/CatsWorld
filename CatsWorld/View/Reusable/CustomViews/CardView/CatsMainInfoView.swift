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
	
	var genderSign: AnyView? {
		if isGender {
			return AnyView(GeometryReader { geometry in
				Text(cat.genderSign)
					.font(.largeTitle)
					.bold()
					.foregroundColor(cat.genderColor)
					.offset(x: 5, y: -6)
			})
			
		} else {
			return nil
		}
	}
	
	var strokeColor: Color = .gray
	
    var body: some View {
		HStack(spacing: 20) {
			CatsAvatar(avatar: cat.wrappedImage)
				.background(
					Circle()
						.stroke(Color.accentColor, lineWidth: 4)
				)
				.frame(minWidth: 40, maxWidth: 100, minHeight: 40, maxHeight: 100)
				.overlay(genderSign)
			
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
			.foregroundColor(.textColor)
		}
    }
}

struct CatsMainInfoView_Previews: PreviewProvider {
	static var previews: some View {
		CatsMainInfoView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), age: .constant(.age))
	}
}
