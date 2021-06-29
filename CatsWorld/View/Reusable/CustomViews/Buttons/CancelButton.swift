//
//  CancelButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

struct CancelButton<Content: View>: View {
	
	var presentationMode: Binding<PresentationMode>?
	var showAlert: Binding<Bool>
	
	var wasChanges: Bool = false
	var action: () -> Void
	
	var content: Content
	
	init(
		presentation: Binding<PresentationMode>? = nil,
		showAlert: Binding<Bool> = .constant(false),
		wasChanges: Bool = false,
		action: @escaping () -> Void = {},
		@ViewBuilder content: () -> Content
	) {
		self.presentationMode = presentation
		self.showAlert = showAlert
		self.wasChanges = wasChanges
		self.action = action
		self.content = content()
	}
	
    var body: some View {
		Button(action: {
			if wasChanges {
				showAlert.wrappedValue = true
			} else {
				if let presentationMode = presentationMode {
					if presentationMode.wrappedValue.isPresented {
						presentationMode.wrappedValue.dismiss()
					}
				}
				action()
			}
		}, label: {
			content
		})
		.frame(width: 50, height: 50)
    }
}

struct CancelButton_Previews: PreviewProvider {
	@Environment(\.presentationMode) static var presentation
    static var previews: some View {
		CancelButton(presentation: presentation) {
			Text("")
		}
    }
}
