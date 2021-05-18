//
//  ImagePickerView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
	
	final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		let parent: ImagePicker
		
		init(_ parent: ImagePicker) {
			self.parent = parent
		}
		
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
			if let uiImage = info[.originalImage] as? UIImage {
				parent.image = uiImage
			}
			
			parent.presentation.wrappedValue.dismiss()
		}
	}
	
	@Environment(\.presentationMode) var presentation
	@Binding var image: UIImage?
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
}
