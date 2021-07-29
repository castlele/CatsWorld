//
//  CatsAvatar.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsAvatar: View {
	
	let avatar: Image
	
	init(avatar: UIImage) {
		self.avatar = Image(uiImage: avatar)
	}
	
	init(avatar: Image) {
		self.avatar = avatar
	}
	
    var body: some View {
        avatar
			.resizable()
			.scaledToFill()
			.background(Color.mainColor)
			.clipShape(Circle())
			.background(
				Circle()
					.stroke(Color.accentColor, lineWidth: 4)
			)
    }
}

struct MutableCornerAvatar: View {
	
	var avatar: Image
	var isStroke = true
	@Binding var cornerRadius: CGFloat
	
	var body: some View {
		avatar
			.resizable()
			.scaledToFill()
			.background(Color.mainColor)
			.cornerRadius(cornerRadius)
			.background(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(isStroke ? Color.accentColor : Color.clear, lineWidth: 4)
			)
	}
}

extension MutableCornerAvatar {
	init(avatar: Image) {
		self.avatar = avatar
		self.isStroke = true
		self._cornerRadius = .constant(CGFloat(20))
	}
	
	init(avatar: Image, isStroke: Bool) {
		self.avatar = avatar
		self.isStroke = isStroke
		self._cornerRadius = .constant(CGFloat(20))
	}
}

struct CatsAvatar_Previews: PreviewProvider {
    static var previews: some View {
		CatsAvatar(avatar: UIImage(systemName: "person.crop.circle.fill")!)
    }
}
