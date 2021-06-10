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
	
	@State var isCatsPageView = false
	
	@State var isColorPicker = false
	
	var cardColor: Color {
		let uiColor = cat.wrappedColor
		return Color(uiColor)
	}
	
    var body: some View {
		
		let colorBinding: Binding<Color> = Binding(
			get: { return cardColor },
			set: { newColor in
				cat.setColor(newColor)
			}
		)
		
		VStack {
			HStack {
				CatsMainInfoView(cat: cat, age: .constant(.age))
				
				Spacer()
				
				HStack {
					Text("\(cat.wrappedSex)")
						.font(.headline)
						.fontWeight(.medium)
						.padding([.leading, .trailing])
					
					Menu {
						Button("Edit") {
							// TODO: - Show `EditCatsPageView`
						}
						
						Button("Pick card's color") {
							withAnimation(.spring()) {
								isColorPicker.toggle()
							}
						}
						
						Button("Delete") {
							withAnimation(.spring()) {
								managedObjectContext.delete(cat)
								do {
									try managedObjectContext.save()
								} catch {
									print(error.localizedDescription)
								}
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
			.onLongPressGesture {
				withAnimation(.spring()) {
					isCatsPageView.toggle()
				}
			}
			
			if isColorPicker {
				ColorPicker("Pick card's Color", selection: colorBinding)
					.onDisappear {
						do {
							try managedObjectContext.save()
						} catch {
							// TODO: - Error handling
							#if DEBUG
							print(error.localizedDescription)
							#endif
						}
					}
			}
		}
		.fullScreenCover(isPresented: $isCatsPageView) {
			CatsPageView(cat: cat, breedsViewModel: BreedsViewModel.shared)
		}
		.padding()
		.frame(minHeight: 100, maxHeight: 150)
		.background(cardColor)
		.clipShape(RoundedRectangle(cornerRadius: 20))
		.volumetricShadows()
    }
}

struct CatsCardView_Previews: PreviewProvider {
    static var previews: some View {
		CatsCardView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext))
    }
}
