//
//  CatsDescriptionSettings.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct CatsDescriptionView: View {
	
	var descriptions: [Description]
	
    var body: some View {
		ForEach(descriptions) { description in
			if description.name != "Description" {
				
				if case let .str(value) = description.value, value.isEmpty {
					EmptyView()
					
				} else if case let .int(value) = description.value, value == 0 {
					EmptyView()
					
				} else {
					HStack {
						Text(description.name).lineLimit(2)
						
						Spacer()
						
						switch description.value {
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
								
							case let .str(value):
								Text(value.capitalized)
									.allowsTightening(true)
									.lineLimit(nil)
									.padding(.vertical)
								
							case let .temperament(value):
								Text(value.rawValue.localize().capitalized)
									.allowsTightening(true)
									.lineLimit(nil)
									.padding(.vertical)
								
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
				
			} else {
				switch description.value {
					case let .str(value):
						Text(value)
						
					default:
						EmptyView()
				}
			}
		}
    }
}

struct CatsDescriptionSettings_Previews: PreviewProvider {
    static var previews: some View {
		CatsDescriptionView(descriptions: [Description("Stranger friendly", CatsWorld.CatsDescriptionValue.int(1)), Description("Child friendly", CatsWorld.CatsDescriptionValue.int(2)), Description("Dog friendly", CatsWorld.CatsDescriptionValue.int(3)), Description("Temperament", CatsWorld.CatsDescriptionValue.temperament(CatsWorld.Temperament.choleric))])
    }
}
