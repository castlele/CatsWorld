//
//  CatsDescriptionSection.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI

struct CatsDescriptionSection<Content: View>: View {
	
	var content: Content
	var backgroundColor: Color
	
    var body: some View {
		ZStack {
			backgroundColor
			
			VStack(spacing: 10) {
				content
					.padding()
					.frame(minHeight: 50)
					.background(
						VStack {
							Spacer()
							Divider()
						}
					)
			}
			
				
		}
		.cornerRadius(20)
		.padding([.leading, .trailing, .bottom])
    }
}

extension CatsDescriptionSection where Content: View {
	init(backgroundColor: Color, @ViewBuilder content: () -> Content) {
		self.backgroundColor = backgroundColor
		self.content = content()
	}
}

struct CatsDescriptionSection_Previews: PreviewProvider {
    static var previews: some View {
		CatsDescriptionSection(backgroundColor: .gray) {
			Text("Hello")
			Text("world")
		}
    }
}
