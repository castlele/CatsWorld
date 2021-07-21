//
//  CatsDescriptionSection.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI

struct CatsDescriptionSection<Content: View>: View {
	
	var content: Content
	var backgroundColor: Color = .mainColor
	
    var body: some View {
		ZStack {
			backgroundColor
			
			VStack(spacing: 10) {
				content
					.padding()
					
					.background(
						VStack {
							Spacer()
							
							Divider()
						}
					)
			}
			
				
		}
		.cornerRadius(20)
    }
}

extension CatsDescriptionSection where Content: View {
	init(backgroundColor: Color = .mainColor, @ViewBuilder content: () -> Content) {
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
