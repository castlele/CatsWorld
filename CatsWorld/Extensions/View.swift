//
//  View.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

extension View {
	
	/// Hides keyboard on LongPress gesture
	func hideKeyboardGesture() -> some View {
		self.modifier(HideKeyboardGesture())
	}
	
	/// Checkes if view is scrolling
	func checkIfScrolling(isScrolling: Binding<Bool>, isDown: Bool = true) -> some View {
		self.modifier(CheckIfScrolling(isScrolling: isScrolling, isDown: isDown))
	}
}
