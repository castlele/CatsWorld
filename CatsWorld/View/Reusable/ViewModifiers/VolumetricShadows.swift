//
//  VolumetricShadows.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 08.06.2021.
//

import SwiftUI

struct VolumetricShadows: ViewModifier {
	
	let color1: Color
	let color2: Color
	
	let radius: CGFloat
	
	let isPressed: Bool
	
	let isInner: Bool
	
	init(color1: Color, color2: Color, radius: CGFloat, isPressed: Bool, isInner: Bool) {
		self.color1 = color1
		self.color2 = color2
		self.radius = radius
		self.isPressed = isPressed
		self.isInner = isInner
	}
	
	func body(content: Content) -> some View {
		if !isInner {
			content
				.shadow(color: color1, radius: isPressed ? radius : radius + 3, x: isPressed ? -5 : -10, y: isPressed ? -5 : -10)
				.shadow(color: color2, radius: isPressed ? radius : radius + 3, x: isPressed ? 5 : 10, y: isPressed ? 5 : 10)
		} else {
			content
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.stroke(color2, lineWidth: 4)
						.blur(radius: isPressed ? radius : radius + 3)
						.mask(RoundedRectangle(cornerRadius: 20)
								.fill(LinearGradient(color2, Color.clear)
								)
						)
				)
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.stroke(color1, lineWidth: 8)
						.blur(radius: isPressed ? radius : radius + 3)
						.mask(RoundedRectangle(cornerRadius: 20)
								.fill(LinearGradient(Color.clear, color2)
								)
						)
				)
		}
	}
}
