//
//  checkIfScrolling.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

/// Checks if view is scrolling
struct CheckIfScrolling: ViewModifier {
	
	@Binding var isScrolling: Bool
	var isDown: Bool = true
	
	func body(content: Content) -> some View {
		content
			.gesture(
				DragGesture()
					.onChanged( { gesture in
						if isDown {
							if gesture.location.y > gesture.startLocation.y {
								withAnimation(.spring()) {
									isScrolling = false
								}
								
							} else {
								withAnimation(.spring()) {
									isScrolling = true
								}
							}
							
						} else {
							if gesture.location.y < gesture.startLocation.y {
								withAnimation(.spring()) {
									isScrolling = false
								}
								
							} else {
								withAnimation(.spring()) {
									isScrolling = true
								}
							}
						}
						
					})
			)
	}
}
