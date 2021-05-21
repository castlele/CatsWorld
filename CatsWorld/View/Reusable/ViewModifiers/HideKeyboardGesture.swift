//
//  HideKeyboardGesture.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

/// Hides keyboard on LongPress gesture
struct HideKeyboardGesture: ViewModifier {
	func body(content: Content) -> some View {
		content
			.gesture(
				LongPressGesture()
					.onEnded( { _ in
						UIApplication.shared.endEditing()
					})
			)
	}
}
