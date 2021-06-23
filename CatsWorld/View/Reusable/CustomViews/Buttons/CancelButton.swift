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
	
	var topImage: Image
	var bottomImage: Image
	var topColor: Color?
	var bottomColor: Color?
	
	var wasChanges: Bool = false
	var action: () -> Void
	
	init(
		presentation: Binding<PresentationMode>,
		topImage: Image,
		bottomImage: Image,
		topColor: Color? = nil,
		bottomColor: Color? = nil,
		showAlert: Binding<Bool> = .constant(false),
		wasChanges: Bool = false,
		action: @escaping () -> Void = {}
	) {
		self.presentationMode = presentation
		self.showAlert = showAlert
		self.topImage = topImage
		self.bottomImage = bottomImage
		self.topColor = topColor
		self.bottomColor = bottomColor
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
			Image3D(
				topView: topImage,
				bottomView: bottomImage,
				topColor: topColor,
				bottomColor: bottomColor
			)
		})
		.buttonStyle(CircleButtonStyle(backGroundColor: Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))))
    }
}

struct CancelButton_Previews: PreviewProvider {
	@Environment(\.presentationMode) static var presentation
    static var previews: some View {
		CancelButton(presentation: presentation, topImage: Image(systemName: "pencil"), bottomImage: Image(systemName: "pencil"))
    }
}
