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
	
	let cat: CatsCard
		
	@ObservedObject var viewModel: HomeScreenViewModel
	
    var body: some View {
		ZStack {
			Color.mainColor
			
			VStack {
				HStack {
					CatsMainInfoView(cat: cat, age: .constant(.age), isAvatar: true)
						.equatable()
					
					GenderSign(genderSign: cat.genderSign, foregroundColor: .primary)
						.equatable()
						.scaleEffect(1.25)
				}
				.frame(minWidth: viewWidth, maxWidth: viewWidth + 20)
				.padding()
				.background(Color(viewModel.pickedColor.rawValue))
				.cornerRadius(20)
				.compositingGroup()
				.volumetricShadows(color1: .clear)
				
				Spacer()
				
				VStack(spacing: 15) {
					ColorPickerView(colors: viewModel.cardsColorPallete.firstHalf, pickedColor: $viewModel.pickedColor)
					
					ColorPickerView(colors: viewModel.cardsColorPallete.secondHalf, pickedColor: $viewModel.pickedColor)
				}
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 20, style: .continuous)
						.fill(Color.mainColor)
				)
				.compositingGroup()
				.volumetricShadows()
				.padding()
				
				Spacer()
				
				DoneButton(action: {
					cat.setColor(viewModel.pickedColor.rawValue)
					
					withAnimation(.spring()) {
						viewModel.isColorPicker.toggle()
					}
				}, content: {
					Text("Submit")
						.foregroundColor(.volumeEffectShadowColor)
						.font(.system(.title, design: .rounded))
						.bold()
				})
				.frame(width: viewWidth * 3/4, height: 50)
				.background(Color.semiAccentColor)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.compositingGroup()
				.volumetricShadows(isPressed: false)
				.padding([.top, .bottom])
			}
		}
		.frame(minWidth: viewWidth, maxWidth: viewWidth + 20, minHeight: minViewHeight, maxHeight: viewHeight)
		.cornerRadius(20)
		.onAppear {
			viewModel.pickedColor = ColorPick(rawValue: viewModel.catsCardsColor)!
		}
		.onDisappear {
			viewModel.isColorPicker = false
		}
    }
}

fileprivate struct ColorPickerView: View {
	
	let colors: [ColorPick]
	@Binding var pickedColor: ColorPick
	
	var body: some View {
		HStack(spacing: 15) {
			ForEach(colors) { color in
				Circle()
					.stroke(Color(color.rawValue).compareColorComponentsWith(Color(pickedColor.rawValue)) ? Color.semiAccentColor : Color.white, lineWidth: 4)
					.overlay(
						Color(color.rawValue)
							.clipShape(Circle())
					)
					.frame(width: 60, height: 60)
					.onTapGesture {
						withAnimation(.spring()) {
							pickedColor = color
						}
					}
			}
		}
	}
}

struct CatsCardsColorPicker_Previews: PreviewProvider {
    static var previews: some View {
		CatsCardsColorPicker(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), viewModel: HomeScreenViewModel())
    }
}
