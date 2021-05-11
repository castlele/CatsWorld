//
//  PawButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

struct PawButton<Button: View>: View {
	
	var buttons: [Button]
	var mainAction: () -> Void
	
	@State var isActivated = false
	
	init(buttons: [Button], action: @escaping () -> Void) {
		guard buttons.count <= 3 else {
			fatalError("Error: There should be 3 or less buttons")
		}
		self.buttons = buttons
		mainAction = action
	}
    var body: some View {
		// If button isn't activated
		if !isActivated {
			MainPawButton(image: "ellipsis", isActivated: $isActivated, action: {})
		} else {
			VStack {
				HStack {
					MainPawButton(image: "ellipsis", isActivated: $isActivated, action: {})
					
					CircleButton(image: "map", action: {})
						.frame(maxWidth: 40, maxHeight: 40)
				}
				
				HStack {
					CircleButton(image: "list.bullet", action: {})
						.frame(maxWidth: 40, maxHeight: 40)
					CircleButton(image: "doc.plaintext", action: {})
						.frame(maxWidth: 40, maxHeight: 40)
						.offset(y: -10)
				}
			}.animation(.spring())
		}
    }
}

private struct MainPawButton: View {
	
	var image: String
	@Binding var isActivated: Bool
	var action: () -> Void
	
	var body: some View {
		CircleButton(image: image) {
			action()
			activateButton()
		}
		.frame(width: 60, height: 60)
	}
	
	func activateButton() -> Void {
		isActivated.toggle()
	}
}

struct PawButton_Previews: PreviewProvider {
    static var previews: some View {
		PawButton(buttons: [CircleButton(image: "", action: {})], action: {})
    }
}
