//
//  CatsMainInfoView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsMainInfoView: View {
	
	var cat: CatsCard
	
    var body: some View {
		HStack(spacing: 20) {
			CatsAvatar(avatar: cat.wrappedImage)
				.frame(minWidth: 40, maxWidth: 60, minHeight: 40, maxHeight: 60)
				.clipShape(Circle())
			
			VStack(alignment: .leading, spacing: 2.5) {
				Text("\(cat.wrappedName)")
					.font(.title)
					.fontWeight(.bold)
				Text("\(cat.age)")
					.font(.footnote)
				Text("\(cat.wrappedBreed)")
					.font(.body)
			}
			
			Text("\(cat.wrappedSex)")
				.font(.title)
				.fontWeight(.medium)
				.padding([.leading, .trailing])
		}
    }
}

struct CatsMainInfoView_Previews: PreviewProvider {
	static var previews: some View {
		CatsPageView(cat: CatsCard(context: PersistenceController.shared.conteiner.viewContext))
	}
}
