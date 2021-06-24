//
//  CircleButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 09.06.2021.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
	
	let backGroundColor: Color
	
	let shadowColor1: Color
	let shadowColor2: Color
	let shadowRadius: CGFloat
	
	init(
		backGroundColor: Color = .white,
		shadowColor1: Color = .white,
		shadowColor2: Color = .gray,
		shadowRadius: CGFloat = 7
	) {
		self.backGroundColor = backGroundColor
		self.shadowColor1 = shadowColor1
		self.shadowColor2 = shadowColor2
		self.shadowRadius = shadowRadius
	}
    
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.background(backGroundColor)
			.clipShape(Circle())
			.volumetricShadows(color1: shadowColor1, color2: shadowColor2, radius: shadowRadius, isPressed: configuration.isPressed)
			.scaleEffect(configuration.isPressed ? 0.95 : 1)
			.animation(.spring())
	}
}
