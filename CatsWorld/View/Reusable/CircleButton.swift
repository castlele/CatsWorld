//
//  CircleButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

struct CircleButton: View {
	
	var image: String
	var action: () -> Void
	
	init(image: String, action: @escaping () -> Void) {
		self.image = image
		self.action = action
	}
	
    var body: some View {
		GeometryReader { geometry in
			Button(action: {
				action()
			}, label: {
				Image(systemName: image)
					.padding()
			})
			.frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
			.foregroundColor(.white)
			.background(Color.green)
			.clipShape(Circle())
			
		}
    }
}

struct CircleButton_Previews: PreviewProvider {
	static func emptyFunc() -> Void {
		print("Hello")
	}
    static var previews: some View {
		CircleButton(image: "list.bullet", action: emptyFunc)
    }
}
