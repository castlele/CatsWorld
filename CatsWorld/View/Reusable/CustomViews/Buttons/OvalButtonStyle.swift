//
//  OvalButtonStyle.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 20.07.2021.
//

import SwiftUI

struct OvalButtonStyle: ButtonStyle {
	
	let backgroundColor: Color
	
	let shadowColor1: Color
	let shadowColor2: Color
	let shadowRadius: CGFloat
	
	init(
		backgroundColor: Color = .mainColor,
		shadowColor1: Color = .volumeEffectShadowColor,
		shadowColor2: Color = .shadowColor,
		shadowRadius: CGFloat = 5
	) {
		self.backgroundColor = backgroundColor
		self.shadowColor1 = shadowColor1
		self.shadowColor2 = shadowColor2
		self.shadowRadius = shadowRadius
	}
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.background(backgroundColor)
			.clipShape(RoundedRectangle(cornerRadius: 20))
			.volumetricShadows(shape: .roundedRect, color1: shadowColor1, color2: shadowColor2, radius: shadowRadius, isPressed: configuration.isPressed)
			.scaleEffect(configuration.isPressed ? 0.85 : 1)
			.animation(.easeInOut)
	}
}
