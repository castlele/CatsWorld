//
//  SearchBarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.07.2021.
//

import SwiftUI

struct SearchBarView: View {
	
	let placeholder: String
	@Binding var text: String
	
    var body: some View {
		HStack {
			HStack {
				Image(systemName: "magnifyingglass")
					.foregroundColor(Color.accentColor)
				
				TextField(placeholder.localize(), text: $text)
				
				if !text.isEmpty {
					Button(action: {
						text = ""
						
					}, label: {
						Image(systemName: "xmark.circle.fill")
							.foregroundColor(Color.accentColor)
					})
				} else {
					EmptyView()
				}
			}
			.padding(3.5)
		}
		.clipShape(RoundedRectangle(cornerRadius: 20))
		.background(
			RoundedRectangle(cornerRadius: 20)
				.stroke(Color.semiAccentColor)
		)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
		SearchBarView(placeholder: "", text: .constant(""))
    }
}
