//
//  CatsCardsColorPicker.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 29.06.2021.
//

import SwiftUI

struct CatsCardsColorPicker: View {
	
	private let viewWidth = UIScreen.screenWidth / 1.2
	private let viewHeight = UIScreen.screenHeight / 1.5
	private let minViewHeight = UIScreen.screenHeight / 1.75
	
	@ObservedObject var cat: CatsCard
	@State var pickedColor: Color
	@Binding var isColorPicker: Bool
	
    var body: some View {
		ZStack {
			Color.mainColor
			
			VStack {
				HStack {
					CatsMainInfoView(cat: cat, age: .constant(.age), isAvatar: true)
					
					GenderSign(genderSign: cat.genderSign, foregroundColor: .textColor)
						.scaleEffect(1.25)
				}
				.frame(minWidth: viewWidth, maxWidth: viewWidth + 20)
				.padding()
				.background(pickedColor)
				.cornerRadius(20)
				.compositingGroup()
				.shadow(color: .shadowColor, radius: 8, x: 10, y: 10)
				.animation(.linear(duration: 0.5))
				
				Spacer()
				
				VStack(spacing: 15) {
					ColorPickerView(colors: ColorPick.firstHalf, pickedColor: $pickedColor)
					
					ColorPickerView(colors: ColorPick.secondHalf, pickedColor: $pickedColor)
				}
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 20, style: .continuous)
						.fill(Color.mainColor)
				)
				.compositingGroup()
				.volumetricShadows()
				.padding()
				.animation(.linear(duration: 0.5))
				
				Spacer()
				
				DoneButton(action: {
					cat.setColor(pickedColor)
					
					withAnimation(.spring()) {
						isColorPicker.toggle()
					}
				}, content: {
					Text("Submit")
						.foregroundColor(.volumeEffectShadowColor)
						.font(.title)
						.bold()
						.frame(width: viewWidth * 3/4, height: 50)
						.background(
							RoundedRectangle(cornerRadius: 20, style: .continuous)
								.fill(Color.semiAccentColor)
						)
						.padding([.bottom, .top])
				})
				.padding(.bottom)
				.compositingGroup()
				.volumetricShadows(isPressed: false)
			}
		}
		.frame(minWidth: viewWidth, maxWidth: viewWidth + 20, minHeight: minViewHeight, maxHeight: viewHeight)
		.cornerRadius(25)
		.offset(x: isColorPicker ? 0 : 100, y: isColorPicker ? 0 : 0)
    }
}

struct ColorPickerView: View {
	
	let colors: [ColorPick]
	@Binding var pickedColor: Color
	
	var body: some View {
		HStack(spacing: 15) {
			ForEach(colors) { color in
				Circle()
					.stroke(Color(color.rawValue) == pickedColor ? Color.semiAccentColor : Color.white, lineWidth: 4)
					.overlay(
						Color(color.rawValue)
							.clipShape(Circle())
					)
					.frame(width: 60, height: 60)
					.onTapGesture {
						withAnimation(.spring()) {
							pickedColor = Color(color.rawValue)
						}
					}
			}
		}
	}
}

struct CatsCardsColorPicker_Previews: PreviewProvider {
    static var previews: some View {
		CatsCardsColorPicker(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), pickedColor: .mainColor, isColorPicker: .constant(true))
    }
}
