//
//  MainCatsPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 10.06.2021.
//

import SwiftUI

struct MainCatsPageView: View {
	
	@Environment(\.presentationMode) var presentationMode
	
	@State var ageType: AgeType = .age
	
	@ObservedObject var cat: CatsCard
	@ObservedObject var catsDescriptionViewModel: CatsDescriptionViewModel
	
	var body: some View {
		GeometryReader { geometry in
			VStack {
				ZStack {
					Rectangle()
						.fill(Color.black.opacity(0.5))
						.blur(radius: 2)
						.offset(x: 0, y: 5)
					Rectangle()
						.fill(Color.white)
					
					VStack {
						HStack {
							Button(action: {
								presentationMode.wrappedValue.dismiss()
								
							}, label: {
								Image3D(
									topView: Image(systemName: "xmark"),
									bottomView: Image(systemName: "xmark"),
									topColor: .white,
									bottomColor: Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
								)
							})
							.frame(width: 50, height: 50)
							.buttonStyle(CircleButtonStyle(backGroundColor: Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))))
							.padding()
							
							Spacer()
							
							Button(action: {
								
							}, label: {
								Image3D(
									topView: Image(systemName: "pencil"),
									bottomView: Image(systemName: "pencil"),
									topColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
									bottomColor: .gray
								)
							})
							.frame(width: 50, height: 50)
							.buttonStyle(CircleButtonStyle())
							.padding()
						}
						.padding(.top)
						
						CatsMainInfoView(cat: cat, age: $ageType, isGender: true)
							.onTapGesture {
								switch ageType {
									case .age:
										ageType = .dateOfBirth
									case .dateOfBirth:
										ageType = .age
								}
							}
							.padding()
						
						Picker("", selection: $catsDescriptionViewModel.category) {
							ForEach(CatsDescriptionCategory.allCases, id: \.self) { category in
								Text(category.rawValue.capitalized)
							}
						}
						.padding([.leading, .trailing, .bottom])
						.labelsHidden()
						.pickerStyle(SegmentedPickerStyle())
					}
				}
				.ignoresSafeArea(edges: .top)
				.frame(width: geometry.frame(in: .local).width, height: geometry.size.width / 2)
				
				TabView(selection: $catsDescriptionViewModel.category) {
					CatsDescriptionSettings(settings: catsDescriptionViewModel.settingsFor(category: .physical))
						.tag(CatsDescriptionCategory.physical)
					CatsDescriptionSettings(settings: catsDescriptionViewModel.settingsFor(category: .psycological))
						.tag(CatsDescriptionCategory.psycological)
					CatsDescriptionSettings(settings: catsDescriptionViewModel.settingsFor(category: .shows))
						.tag(CatsDescriptionCategory.shows)
				}
				.tabViewStyle(PageTabViewStyle())
				.animation(.spring())
				
				Spacer()
				
				if let additionalInfo = cat.additionalInfo, !additionalInfo.isEmpty {
					Text(additionalInfo)
				}
			}
			.background(Color(cat.wrappedColor).blur(radius: 200))
			.onAppear {
				UIScrollView.appearance().bounces = true
			}
			.onDisappear {
				UIScrollView.appearance().bounces = false
			}
		}
	}
}

struct MainCatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		MainCatsPageView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), catsDescriptionViewModel: CatsDescriptionViewModel(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext)))
    }
}
