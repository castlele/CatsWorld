//
//  EditButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct EditButton: View {
	
	@Binding var isEditing: Bool
	
    var body: some View {
		Button(action: {
			isEditing.toggle()
		}, label: {
			Text("Edit")
		})
    }
}

struct EditButton_Previews: PreviewProvider {
    static var previews: some View {
		EditButton(isEditing: .constant(false))
    }
}
