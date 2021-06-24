//
//  MapView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import SwiftUI
import MapKit

struct MapTabView: View {
	
	@State var mapRect = MKMapRect(
		origin: MKMapPoint(
			CLLocationCoordinate2D(
				latitude: 30.3609,
				longitude: 59.9311
			)
		),
		size: MKMapSize(width: 10000, height: 10000)
	)
	
    var body: some View {
		Map(mapRect: $mapRect)
    }
}

struct MapTabView_Previews: PreviewProvider {
    static var previews: some View {
		MapTabView()
    }
}
