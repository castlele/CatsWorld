//
//  CatsDescriptionSettings.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct CatsDescriptionSettings: View {
	
	@State var settings: [Setting]
	
    var body: some View {
		VStack {
			ForEach(0..<settings.count) { index in
				HStack {
					Text(settings[index].name)
					
					Spacer()
					
					switch settings[index].value {
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
							Text("\(value.rawValue.capitalized)")
							
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
}

struct CatsDescriptionSettings_Previews: PreviewProvider {
    static var previews: some View {
		CatsDescriptionSettings(settings: [(name: "Stranger friendly", value: CatsWorld.CatsDescriptionValue.int(1)), (name: "Child friendly", value: CatsWorld.CatsDescriptionValue.int(2)), (name: "Dog friendly", value: CatsWorld.CatsDescriptionValue.int(3)), (name: "Temperament", value: CatsWorld.CatsDescriptionValue.temperament(CatsWorld.Temperament.choleric))])
    }
}
