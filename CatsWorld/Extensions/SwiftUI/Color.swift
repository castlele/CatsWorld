//
//  Color.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 24.06.2021.
//

import SwiftUI

// MARK: - Initialisations
extension Color {
	
	typealias ColorComponents = (red: Double, green: Double, blue: Double, alpha: Double)
	
	/// Initialization in `.sRGB` Color space with withc given color components
	init(_ colorComponents: ColorComponents) {
		self.init(.sRGB,
				  red: colorComponents.red,
				  green: colorComponents.green,
				  blue: colorComponents.blue,
				  opacity: colorComponents.alpha
		)
	}
}

// MARK: - Properties
extension Color {
	static let accentColor = Color("accentColor")
	static let semiAccentColor = Color("semiAccentColor")
	static let volumeEffectColorTop = Color("3DEffectColorTop")
	static let volumeEffectColorBottom = Color("3DEffectColorBottom")
	static let mainColor = Color("mainColor")
	static let shadowColor = Color("shadowColor")
	static let volumeEffectShadowColor = Color("3DEffectShadowColor")
	
	/// Represent color components of `Self`
	private var colorComponents: (red: Double, green: Double, blue: Double, alpha: Double) {
		let uiColor = UIColor(self)
		
		var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
		
		uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		return (Double(red), Double(green), Double(blue), Double(alpha))
	}
}

// MARK: - Public methods
extension Color {
	
	/// Returns `Color.mainColor` as `UIColor`
	static func mainUIColor() -> UIColor { UIColor(named: "mainColor")! }
	
	/// Returns `Color.accentColor` as `UIColor`
	static func accentUIColor() -> UIColor { UIColor(named: "accentColor")! }
	
	/// Returns `Color.lightAccent` as `UIColor`
	static func lightAccentUIColor() -> UIColor { UIColor(named: "lightAccent")! }
	
	/// Returns `Color.darkAccent` as `UIColor`
	static func darkAccentUIColor() -> UIColor { UIColor(named: "darkAccent")! }
	
	/// Returns `Color.semiAccentColor` as `UIColor`
	static func semiAccentUIColor() -> UIColor { UIColor(named: "semiAccentColor")! }
	
	/// Returns `Color.volumeEffectShadowColor` as `UIColor`
	static func lightUIColor() -> UIColor { UIColor(Color.volumeEffectShadowColor) }
	
	/// Makes `Color` lighter by given rate
	/// - Parameter rate: Сoefficient (0.0...1.0)
	/// - Returns: `Color`, which is lighter, than `self` was
	func lighter(by rate: Double) -> Color {
		adjust(by: abs(rate))
	}
	
	/// Makes `Color` darker by given rate
	/// - Parameter rate: Coefficient (0.0...1.0)
	/// - Returns: `Color`, which is darker, than `self` was
	func darker(by rate: Double) -> Color {
		adjust(by: -1 * abs(rate))
	}
	
	/// Compares self color components with anothor
	/// - Parameter color: `Color` to check equality
	/// - Returns: true if `Self` color components are equal to `color` color components
	/// otherwise returns false
	func compareColorComponentsWith(_ color: Color) -> Bool {
		self.colorComponents == color.colorComponents
	}
}

// MARK: - Private methods
extension Color {
	
	/// Adjust `self` by given rate and return new `Color`
	/// - Parameter rate: Coefficient (0.0...1.0)
	/// - Returns: Adjusted by `rate` `Color`
	private func adjust(by rate: Double) -> Color {
		let (red, green, blue, alpha) = colorComponents
		
		let adjustedComponents: ColorComponents = (red: min(red + red * rate, 1.0),
												   green: min(green + green * rate, 1.0),
												   blue: min(blue + blue * rate, 1.0),
												   alpha: alpha
												   )
		
		return Color(adjustedComponents)
	}
}
