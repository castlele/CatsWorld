//
//  CancelButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

struct CancelButton: View {
	
	var presentationMode: Binding<PresentationMode>
	var showAlert: Binding<Bool>
	
	var wasChanges: Bool = false
	var action: () -> Void
	
	init(presentation: Binding<PresentationMode>, showAlert: Binding<Bool> = .constant(false), wasChanges: Bool = false, action: @escaping () -> Void = {}) {
		self.presentationMode = presentation
		self.showAlert = showAlert
		self.wasChanges = wasChanges
		self.action = action
	}
	
    var body: some View {
		Button(action: {
			if wasChanges {
				showAlert.wrappedValue = true
			} else {
				if presentationMode.wrappedValue.isPresented {
					action()
					presentationMode.wrappedValue.dismiss()
				}
			}
		}, label: {
			Text("Cancel")
		})
    }
}

struct CancelButton_Previews: PreviewProvider {
	@Environment(\.presentationMode) static var presentation
    static var previews: some View {
		CancelButton(presentation: presentation)
    }
}
