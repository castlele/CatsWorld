//
//  EditButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct EditButton<Content: View>: View {
	
	@Binding var isEditing: Bool
	@ViewBuilder var content: Content
	
    var body: some View {
		Button(action: {
			isEditing.toggle()
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
