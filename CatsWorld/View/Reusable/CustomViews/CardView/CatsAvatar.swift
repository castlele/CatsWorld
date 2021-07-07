//
//  CatsAvatar.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsAvatar: View {
	
	let avatar: UIImage?
	
	var image: Image {
		if let avatar = avatar {
			return Image(uiImage: avatar)
		} else {
			return Image(systemName: "person.crop.circle.fill")
		}
	}
	
    var body: some View {
        image
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
