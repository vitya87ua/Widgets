//
//  SmallWidgetView.swift
//  AirNOWWidgetExtension
//
//  Created by Віктор Бережницький on 15.04.2021.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    
    private var model: LUNViewModel
    
    init(model: LUNViewModel) {
        self.model = model
    }
    
    
    var body: some View {

        ZStack {
            
            // Backgroung LinearGradient
            LinearGradient(gradient: Gradient(colors: model.widgetUi.color), startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: -8, content: {
                HStack {
                    
                    // Location arrow
                    Image(systemName: "location.fill")
                        .resizable()
                        .frame(width: 12, height: 12, alignment: .center)
                        .foregroundColor(.white)
                        .padding(.trailing, -5)
                    
                    // District
                    Text(model.district)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.white)

                    
                    Spacer(minLength: 2)
                    
                    // Logo
                    Image("cloudPic")
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                }
                
                // 6 AQI Updated
                HStack(alignment: .lastTextBaseline, spacing: 2, content:  {
                    
                    Text(model.aqiIndex == "" ? "0" : model.aqiIndex)
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(.white)
                    
                    Text("AQI")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                })
                
                // Description & advice
                Text(model.widgetUi.description)
                    .font(.system(size: 14, weight: .semibold))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .padding(.top, 3)
                
                Spacer()
                
                Text("updated".localized + " " + model.time)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                
            })
            .padding(.all, 13)
        }
        
    }
}

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView(model: LUNViewModel.getMockElement(condition: .Good))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
