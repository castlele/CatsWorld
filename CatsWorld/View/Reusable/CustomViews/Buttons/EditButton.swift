//
//  EditButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct EditButton<Content: View>: View {
	
	var isEditing: Binding<Bool>
	var action: () -> Void
	@ViewBuilder var content: Content
	
	init(isEditing: Binding<Bool>, @ViewBuilder content: () -> Content) {
		self.isEditing = isEditing
		self.action = {}
		self.content = content()
	}
	
	init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
		self.isEditing = .constant(false)
		self.action = action
		self.content = content()
	}
	
    var body: some View {
		Button(action: {
			action()
			
			isEditing.wrappedValue.toggle()
			
		}, label: {
			content
		})
    }
}

struct EditButton_Previews: PreviewProvider {
    static var previews: some View {
		EditButton(isEditing: .constant(false)) { Text("") }
    }
}
