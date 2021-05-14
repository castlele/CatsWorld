//
//  CatsCardView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//

import SwiftUI

struct CatsCardView: View {
	
	var name: String?
	var age: Int16?
	var breed: String?
	var imageData: Data?
	
	var image: Image {
		if let imageData = imageData {
			if let uiImage = UIImage(data: imageData) {
				return Image(uiImage: uiImage)
			}
		}
		return Image(systemName: "person.crop.circle.fill")
	}
	
    var body: some View {
		GeometryReader { geometry in
			HStack(spacing: 20) {
				image
					.resizable()
					.background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
					.frame(minWidth: 40, minHeight: 40)
					.clipShape(Circle())
				
				VStack(alignment: .leading, spacing: 2.5) {
					Text("\(name ?? "None")")
						.font(.title)
						.fontWeight(.bold)
					Text("\(age ?? 0)")
						.font(.footnote)
					Text("\(breed ?? "None")")
						.font(.body)
				}
				
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
			.background(Color(#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)))
			.clipShape(RoundedRectangle(cornerRadius: 20))
		}
    }
}

struct CatsCardView_Previews: PreviewProvider {
    static var previews: some View {
		CatsCardView(name: "Lulu", age: 5, breed: "Unicorn")
    }
}
