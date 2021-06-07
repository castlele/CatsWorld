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
					
					HStack {
						Text("\(cat.wrappedSex)")
							.font(.headline)
							.fontWeight(.medium)
							.padding([.leading, .trailing])
						
						Menu {
							Button("Pick card's color") {
								withAnimation(.spring()) {
									isColorPicker.toggle()
								}
							}
							
							Button("Delete") {
								withAnimation(.spring()) {
									managedObjectContext.delete(cat)
								}
							}
							
						} label: {
							HStack(spacing: 5) {
								ForEach(0..<3) { circle in
									Circle()
										.frame(width: 10, height: 10)
								}
							}
							.padding(.trailing)
						}
						.accentColor(.black)
					}
					
				}
				
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
			.padding()
			.frame(maxWidth: geometry.size.width, maxHeight: 100)
			.background(
				ZStack {
					cardColor
					
					RoundedRectangle(cornerRadius: 20, style: .continuous)
						.shadow(color: .white, radius: 7, x: -5, y: -5)
						.shadow(color: .black, radius: 7, x: 5, y: 5)
						.blendMode(.overlay)
				}
			)
			.clipShape(RoundedRectangle(cornerRadius: 20))
			.shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
			
		}
    }
}

struct CatsCardView_Previews: PreviewProvider {
    static var previews: some View {
		CatsCardView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext))
    }
}
