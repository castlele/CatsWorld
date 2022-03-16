//
//  WheelPickerView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 01.08.2021.
//

import SwiftUI

struct PickerRow: View {
	
	let cat: CatsCard
	
	var body: some View {
		HStack {
			CatsAvatar(avatar: cat.wrappedImage)
				.frame(width: 50, height: 50)
			
			CatsMainInfoView(cat: cat, ageType: .constant(.dateOfBirth), isGender: true, isAvatar: false)
				.frame(height: 50)
		}
		.padding()
	}
}

struct WheelPickerView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@Binding var picked: UUID
	
	var cats: [CatsCard] {
		do {
			return try managedObjectContext.fetch(CatsCard.fetchRequest())
		} catch {
			return []
		}
	}
	
	var count: Int { cats.count }
	
    var body: some View {
		ScrollView(showsIndicators: false) {
			Divider()
			
			VStack(spacing: 0) {
				ForEach(0..<count - 1) { index in
					PickerRow(cat: cats[index])
						.rotation3DEffect(
							Angle(degrees: 10),
							axis: (1, 0, 0),
							anchor: .top,
							anchorZ: 0,
							perspective: 2.5
						)
					
					Divider()
				}
			}
		}
		.background(Color.mainColor)
    }
}

struct Carousel<Items: View>: View {
	var body: some View {
		HStack {
			
		}
	}
}

struct WheelPickerView_Previews: PreviewProvider {

    static var previews: some View {
		WheelPickerView(picked: .constant(UUID()))
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
			.frame(height: 300)
    }
}
