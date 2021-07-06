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
		
	@ObservedObject var viewModel: HomeScreenViewModel
	
    var body: some View {
		ZStack {
			Color.mainColor
			
			VStack {
				HStack {
					CatsMainInfoView(cat: viewModel.getCat(), age: .constant(.age), isAvatar: true)
						.equatable()
					
					GenderSign(genderSign: viewModel.getCat().genderSign, foregroundColor: .textColor)
						.equatable()
						.scaleEffect(1.25)
				}
				.frame(minWidth: viewWidth, maxWidth: viewWidth + 20)
				.padding()
				.background(viewModel.pickedColor)
				.cornerRadius(20)
				.compositingGroup()
				.shadow(color: .shadowColor, radius: 8, x: 10, y: 10)
				
				Spacer()
				
				VStack(spacing: 15) {
					ColorPickerView(colors: ColorPick.firstHalf, pickedColor: $viewModel.pickedColor)
						.equatable()
					
					ColorPickerView(colors: ColorPick.secondHalf, pickedColor: $viewModel.pickedColor)
						.equatable()
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
					viewModel.getCat().setColor(viewModel.pickedColor)
					
					withAnimation(.spring()) {
						viewModel.isColorPicker.toggle()
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
				.onAppear {
					viewModel.pickedColor = viewModel.catsCardsColor
				}
			}
		}
		.frame(minWidth: viewWidth, maxWidth: viewWidth + 20, minHeight: minViewHeight, maxHeight: viewHeight)
		.cornerRadius(25)
    }
}

fileprivate struct ColorPickerView: View, Equatable {
	
	let colors: [ColorPick]
	@Binding var pickedColor: Color
	
	var body: some View {
		HStack(spacing: 15) {
			ForEach(colors) { color in
				Circle()
					.stroke(Color(color.rawValue).compareColorComponentsWith(pickedColor) ? Color.semiAccentColor : Color.white, lineWidth: 4)
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
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.pickedColor.compareColorComponentsWith(rhs.pickedColor) && lhs.colors.count == rhs.colors.count
	}
}

struct CatsCardsColorPicker_Previews: PreviewProvider {
    static var previews: some View {
		CatsCardsColorPicker(viewModel: HomeScreenViewModel())
    }
}
