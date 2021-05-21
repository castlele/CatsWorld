//
//  MultilineTextFieldView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 20.05.2021.
//

import SwiftUI

// MARK:- Properties and UIViewRepresentable methods
struct MultilineTextFieldView: UIViewRepresentable {
	
	/// Editable by user text
	@Binding var text: String
	
	/// Temporary placeholder
	/// Live until `text.isEmpty == true`
	let placeholder: String

	func makeUIView(context: UIViewRepresentableContext<MultilineTextFieldView>) -> UITextView {
		let textView = UITextView()
		textView.delegate = context.coordinator
		setupTextView(textView)
		
		return textView
	}
	
	/// Sets up `textView`
	/// - Parameter view: Instance of `UITextView`, which should be set up
	private func setupTextView(_ view: UITextView) {
		if text.isEmpty {
			view.text = placeholder
		} else {
			view.text = text
		}
		
		view.isEditable = true
		view.isUserInteractionEnabled = true
		view.isScrollEnabled = true
		view.font = .systemFont(ofSize: 15)
		view.backgroundColor = .clear
	}
	
	func updateUIView(_ uiViewController: UITextView, context: Context) {
		
	}
}

// MARK:- Coordinator
extension MultilineTextFieldView {
	
	/// Describes how `MultilineTextFieldView` is working when changes occure
	final class Coordinator: NSObject, UITextViewDelegate {
		
		let parent: MultilineTextFieldView
		
		init(_ parent: MultilineTextFieldView) {
			self.parent = parent
		}
		
		func textViewDidChange(_ textView: UITextView) {
			/// Changing parent's `text`
			self.parent.text = textView.text
		}
		
		func textViewDidBeginEditing(_ textView: UITextView) {
			// TODO:- Make it work
//			let rect = KeyboardManager.shared.keyboardFrame
//			textView.scrollRectToVisible(rect, animated: true)
			
			if textView.text == parent.placeholder {
				textView.text = ""
			}
		}
		
		func textViewDidEndEditing(_ textView: UITextView) {
			if textView.text.isEmpty {
				textView.text = parent.placeholder
			}
		}
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}
}
