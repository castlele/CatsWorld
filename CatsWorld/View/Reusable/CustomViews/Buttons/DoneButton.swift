//
//  DoneButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

struct DoneButton: View {
	
	var presentationMode: Binding<PresentationMode>
	var action: () -> Void
	
	init(presentation: Binding<PresentationMode>, action: @escaping () -> Void) {
		self.presentationMode = presentation
		self.action = action
	}
	
    var body: some View {
		Button(action: {
			action()
			if presentationMode.wrappedValue.isPresented {
				presentationMode.wrappedValue.dismiss()
			}
			
		}, label: {
			Text("Done")
		})
    }
}

struct DoneButton_Previews: PreviewProvider {
	@Environment(\.presentationMode) static var presentation

    static var previews: some View {
		DoneButton(presentation: presentation, action: { })
    }
}
