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
			.scaledToFit()
			.background(Color.mainColor)
			.clipShape(Circle())
			.background(
				Circle()
					.stroke(Color.accentColor, lineWidth: 4)
			)
    }
}

struct CatsAvatar_Previews: PreviewProvider {
    static var previews: some View {
		CatsAvatar(avatar: UIImage(systemName: "person.crop.circle.fill")!)
    }
}
