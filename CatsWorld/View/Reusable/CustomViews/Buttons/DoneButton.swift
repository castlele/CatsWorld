//
//  DoneButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

struct DoneButton<Content: View>: View {
	
	var presentationMode: Binding<PresentationMode>?
	var content: Content
	var action: () -> Void
	
	init(presentation: Binding<PresentationMode>? = nil, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
		self.presentationMode = presentation
		self.action = action
		self.content = content()
	}
	
    var body: some View {
		Button(action: {
			action()
			
			if let presentationMode = presentationMode {
				if presentationMode.wrappedValue.isPresented {
					presentationMode.wrappedValue.dismiss()
				}
			}
			
		}, label: {
			content
		})
    }
}

struct DoneButton_Previews: PreviewProvider {
	@Environment(\.presentationMode) static var presentation

    static var previews: some View {
		DoneButton(presentation: presentation, action: { }, content: {Text("Done")})
    }
}
