//
//  VolumetricShadows.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 08.06.2021.
//

import SwiftUI

struct VolumetricShadows<Shape: View>: ViewModifier {
	
	let shadowType = SettingsViewModel.shared.wrappedShadows
	let shape: Shape
	
	let color1: Color
	let color2: Color
	
	let radius: CGFloat
	
	let isPressed: Bool
		
	init(shape: Shape, color1: Color, color2: Color, radius: CGFloat, isPressed: Bool) {
		self.shape = shape
		self.color1 = color1
		self.color2 = color2
		self.radius = radius
		self.isPressed = isPressed
	}
	
	func body(content: Content) -> some View {
		switch shadowType {
			case .appDefault:
				return AnyView(makeDefaultShadows(content: content))
			case .flat:
				return AnyView(makeFlatShadows(content: content))
			case .disabled:
				return AnyView(disableShadows(content: content))
		}
	}
	
	private func makeDefaultShadows(content: Content) -> some View {
		content
			.shadow(color: color1, radius: isPressed ? radius : radius + 3, x: isPressed ? -5 : -10, y: isPressed ? -5 : -10)
			.shadow(color: color2, radius: isPressed ? radius : radius + 3, x: isPressed ? 5 : 10, y: isPressed ? 5 : 10)
	}
	
	private func makeFlatShadows(content: Content) -> some View {
		content
			.background(
				shape
					.foregroundColor(color2)
					.offset(x: 7, y: 7)
			)
	}
	
	private func disableShadows(content: Content) -> some View {
		content
			.background(
				shape
					.foregroundColor(color2)
					.scaleEffect(1.1)

			)
	}
}
