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
	var isEditing: Binding<Bool>
	
	var wasChanges: Bool = false
	var action: () -> Void
	
	init(presentation: Binding<PresentationMode>, showAlert: Binding<Bool>, isEditing: Binding<Bool>, wasChanges: Bool, action: @escaping () -> Void) {
		self.presentationMode = presentation
		self.showAlert = showAlert
		self.isEditing = isEditing
		self.wasChanges = wasChanges
		self.action = action
	}
	
    var body: some View {
		Button(action: {
			if wasChanges {
				showAlert.wrappedValue = true
				isEditing.wrappedValue = false
			} else {
				if presentationMode.wrappedValue.isPresented {
					isEditing.wrappedValue = false
					action()
					presentationMode.wrappedValue.dismiss()
				}
			}
		}, label: {
			Text("Cancel")
		})
    }
}

//struct CancelButton_Previews: PreviewProvider {
//	@Environment(\.presentationMode) static var presentation
//    static var previews: some View {
//		CancelButton(presentationMode: presentation, showAlert: .constant(true), isEditing: .constant(false))
//    }
//}
