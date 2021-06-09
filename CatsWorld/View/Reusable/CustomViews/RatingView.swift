//
//  RatingView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 19.05.2021.
//

import SwiftUI

/// View representing Rating system
struct RatingView: View {
	
	@Binding var rating: Int
	var maxRating = 5
	
	var label: String = ""
	var offImage: Image
	var onImage: Image
	var offColor: Color = .gray
	var onColor: Color = .yellow
	
    var body: some View {
		HStack {
			if !label.isEmpty {
				Text(label)
			}
			
			Spacer()
			
			ForEach(1..<maxRating + 1) { rating in
				if self.rating >= rating {
					onImage
						.foregroundColor(onColor)
						.onTapGesture {
							self.rating = rating
						}
				} else {
					offImage
						.foregroundColor(offColor)
						.onTapGesture {
							self.rating = rating
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
