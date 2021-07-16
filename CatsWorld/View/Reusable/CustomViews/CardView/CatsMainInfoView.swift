//
//  CatsMainInfoView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

extension CatsMainInfoView: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.ageType == rhs.ageType &&
			lhs.catsName == rhs.catsName &&
			lhs.catsBreed == rhs.catsBreed &&
			lhs.catsDateOfBirth == rhs.catsDateOfBirth &&
			lhs.cat.image == rhs.cat.image
	}
}

struct CatsMainInfoView: View {
	
	@ObservedObject var cat: CatsCard
	
	@Binding var ageType: AgeType
	
	var isGender = false
	var isAvatar = false
	
	var wrappedAge: String {
		switch ageType {
			case .age:
				return catsAge
			case .dateOfBirth:
				return catsDateOfBirth
		}
	}
	
	var catsName: String { cat.wrappedName }
	var catsGenderSign: String { cat.genderSign }
	var catsGenderColor: Color { cat.genderColor }
	var catsAge: String { cat.age }
	var catsDateOfBirth: String { cat.wrappedDateOfBirth }
	var catsBreed: String { cat.wrappedBreed.localize() }
	
	var genderSign: AnyView? {
		if isGender {
			return AnyView(GenderSign(genderSign: catsGenderSign, foregroundColor: catsGenderColor)
							.equatable()
							.scaleEffect(1.25)
			)
		}
		return nil
	}
		
    var body: some View {
		HStack(spacing: 20) {
			if isAvatar {
				CatsAvatar(avatar: cat.wrappedImage)
					.frame(minWidth: 50, maxWidth: 100, minHeight: 50, maxHeight: 100)
					.overlay(
						GeometryReader { _ in
							genderSign
						}
					)
			}
			
			VStack(alignment: .leading, spacing: 2.5) {
				Text(catsName)
					.font(.system(.body, design: .rounded))
					.fontWeight(.bold)
					.lineLimit(1)
				
				Text(wrappedAge)
					.font(.system(size: 12, weight: .light, design: .rounded))
				
				Text(catsBreed)
					.font(.system(size: 13, weight: .medium, design: .rounded))
					.allowsTightening(true)
					.lineLimit(2)
					
					
			}
			.frame(width: 95, alignment: .leading)
			.minimumScaleFactor(0.1)
			
			Spacer()
		}
    }
}

struct CatsMainInfoView_Previews: PreviewProvider {
	static var cat: CatsCard = {
		let cat = CatsCard(context: PersistenceController.preview.conteiner.viewContext)
		cat.name = "Long Long Name"
		cat.breed = "Шоколадный Йорк"
		return cat
	}()
	static var previews: some View {
		CatsMainInfoView(cat: cat, ageType: .constant(.age))
	}
}
