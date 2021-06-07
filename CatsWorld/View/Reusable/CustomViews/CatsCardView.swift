//
//  CatsCardView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//

import SwiftUI

struct CatsCardView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@ObservedObject var cat: CatsCard
	
	@State var isColorPicker = false
	@State var isSave = false
	
	var cardColor: Color {
		let uiColor = cat.wrappedColor
		return Color(uiColor)
	}
	
    var body: some View {
		
		let colorBinding: Binding<Color> = Binding(
			get: { return cardColor },
			set: { newColor in
				if newColor != cardColor {
					cat.setColor(newColor)
				}
			}
		)
		
		GeometryReader { geometry in
			VStack {
				HStack {
					CatsMainInfoView(cat: cat)
					
					Spacer()
					
					Menu {
						Button(action: {
							isColorPicker.toggle()
							
						}, label: {
							Text("Pick card's color")
						})
						
					} label: {
						HStack(spacing: 5) {
							ForEach(0..<3) { circle in
								Circle()
									.frame(width: 10, height: 10)
							}
						}
					}
				}
				.padding()
				.frame(minWidth: geometry.size.width, minHeight: geometry.size.width / 2)
				.background(cardColor)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				
				if isColorPicker {
					ColorPicker("Pick card's Color", selection: colorBinding)
						.onDisappear {
							do {
								try managedObjectContext.save()
							} catch {
								#if DEBUG
								print(error.localizedDescription)
								#endif
							}
						}
				}
			}
		}
    }
}

struct CatsCardView_Previews: PreviewProvider {
    static var previews: some View {
		CatsCardView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext))
    }
}
