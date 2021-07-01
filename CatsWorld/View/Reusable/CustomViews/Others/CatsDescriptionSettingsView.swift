//
//  CatsDescriptionSettings.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct CatsDescriptionSettingsView: View {
	
	@State var settings: [Setting]
	
    var body: some View {
		ForEach(settings) { setting in
			HStack {
				Text(setting.name)
				
				Spacer()
				
				switch setting.value {
					case let .bool(value):
						value ? Text("Yes") : Text("No")
						
					case let .int(value):
						RatingView(rating: .constant(Int(value)),
												  offImage: Image(systemName: "star"),
												  onImage: Image(systemName: "star.fill"),
												  isEditing: false
						)
					case let .float(value):
						Text("\(value, specifier: "%.1f") kg")
						
					case let .temperament(value):
						Text(value.rawValue.localize().capitalized)
						
					case let .showsArray(value):
						List {
							ForEach(value) { show in
								Text("\(show.name)")
							}
						}
				}
			}
			.padding()
		}
    }
}

struct CatsDescriptionSettings_Previews: PreviewProvider {
    static var previews: some View {
		CatsDescriptionSettingsView(settings: [Setting("Stranger friendly", CatsWorld.CatsDescriptionValue.int(1)), Setting("Child friendly", CatsWorld.CatsDescriptionValue.int(2)), Setting("Dog friendly", CatsWorld.CatsDescriptionValue.int(3)), Setting("Temperament", CatsWorld.CatsDescriptionValue.temperament(CatsWorld.Temperament.choleric))])
    }
}
