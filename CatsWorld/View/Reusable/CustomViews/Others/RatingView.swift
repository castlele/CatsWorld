//
//  RatingView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 19.05.2021.
//

import SwiftUI

/// View representing Rating system
struct RatingView<Content: View>: View {
	
	var rating: Binding<Int>
	let maxRating: Int
	
	let label: String
	let offImage: Content
	let onImage: Content
	let offColor: Color
	let onColor: Color
	
	let isEditing: Bool
	
	init(
		rating: Binding<Int>,
		maxRating: Int = 5,
		label: String = "",
		offImage: Content,
		onImage: Content,
		offColor: Color = .gray,
		onColor: Color = .yellow,
		isEditing: Bool = true
	) {
		self.rating = rating
		self.maxRating = maxRating
		self.label = label
		self.offImage = offImage
		self.onImage = onImage
		self.offColor = offColor
		self.onColor = onColor
		self.isEditing = isEditing
	}
	
    var body: some View {
		HStack {
			Text(label)

			Spacer()
			
			if isEditing {
				ForEach(1..<maxRating + 1) { rating in
					if self.rating.wrappedValue >= rating {
						onImage
							.foregroundColor(onColor)
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.5)) {
									self.rating.wrappedValue = rating
								}
							}
					} else {
						offImage
							.foregroundColor(offColor)
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.5)) {
									self.rating.wrappedValue = rating
								}
							}
					}
				}
			} else {
				ForEach(1..<maxRating + 1) { rating in
					if self.rating.wrappedValue >= rating {
						onImage
							.foregroundColor(onColor)
					} else {
						offImage
							.foregroundColor(offColor)
					}
				}
			}
		}
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
		RatingView(rating: .constant(1), label: "Rating", offImage: Image(systemName: "star"), onImage: Image(systemName: "star.fill"))
    }
}
