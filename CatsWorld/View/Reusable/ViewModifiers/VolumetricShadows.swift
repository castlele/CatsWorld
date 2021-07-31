//
//  VolumetricShadows.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 08.06.2021.
//

import SwiftUI

struct VolumetricShadows: ViewModifier {
	
	enum ShapeType {
		case circle
		case roundedRect
		case rect
	}
	
	let shadowType: AppShadow = SettingsViewModel.shared.wrappedShadows
	
	let shape: ShapeType
	
	let color1: Color
	let color2: Color
	
	let radius: CGFloat
	
	let isPressed: Bool
		
	init(shape: VolumetricShadows.ShapeType, color1: Color, color2: Color, radius: CGFloat, isPressed: Bool) {
		self.shape = shape
		self.color1 = color1
		self.color2 = color2
		self.radius = radius
		self.isPressed = isPressed
	}
	
	var wrappedShapeForFlatShadows: some View {
		switch shape {
			case .circle:
				return AnyView(Circle().fill(color2))
			case .roundedRect:
				return AnyView(RoundedRectangle(cornerRadius: 20).fill(color2))
			case .rect:
				return AnyView(Rectangle().fill(color2))
		}
	}
	
	var wrappedShapeForDisablesShadows: some View {
		switch shape {
			case .circle:
				return AnyView(Circle().stroke(color2, lineWidth: 2.5))
			case .roundedRect:
				return AnyView(RoundedRectangle(cornerRadius: 20).stroke(color2, lineWidth: 2.5))
			case .rect:
				return AnyView(Rectangle().stroke(
								LinearGradient(
									gradient: Gradient(colors: [.clear, .clear, .clear, color2]),
									startPoint: .top, endPoint: .bottom
								), lineWidth: 2.5))
		}
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
				wrappedShapeForFlatShadows
					.offset(x: 5, y: 5)
			)
	}
	
	private func disableShadows(content: Content) -> some View {
		content
			.overlay(
				GeometryReader { geometry in
					wrappedShapeForDisablesShadows
						.frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height)
				}
			)
	}
}
