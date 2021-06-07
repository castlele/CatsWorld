//
//  CatsMainInfoView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsMainInfoView: View {
	
	@ObservedObject var cat: CatsCard
	
    var body: some View {
		HStack(spacing: 20) {
			CatsAvatar(avatar: cat.wrappedImage)
				.frame(minWidth: 40, maxWidth: 60, minHeight: 40, maxHeight: 60)
				.clipShape(Circle())
			
			VStack(alignment: .leading, spacing: 2.5) {
				Text("\(cat.wrappedName)")
					.font(.body)
					.fontWeight(.bold)
				Text("\(cat.age)")
					.font(.footnote)
				Text("\(cat.wrappedBreed)")
					.font(.subheadline)
					.lineLimit(2)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
    }
}

struct CatsMainInfoView_Previews: PreviewProvider {
	static var previews: some View {
		CatsMainInfoView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext))
	}
}
