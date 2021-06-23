//
//  CatsAvatar.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsAvatar: View {
	
	var avatar: UIImage?
	
	var image: Image {
		if let avatar = avatar {
			return Image(uiImage: avatar)
		} else {
			return Image(systemName: "person.crop.circle.fill")
		}
	}
	
    var body: some View {
        image
			.interpolation(.high)
			.resizable()
			.background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
			.clipShape(Circle())
    }
}

struct CatsAvatar_Previews: PreviewProvider {
    static var previews: some View {
		CatsAvatar(avatar: UIImage(systemName: "person.crop.circle.fill")!)
    }
}
