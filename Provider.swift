//
//  Provider.swift
//  AirNOWWidgetExtension
//
//  Created by Віктор Бережницький on 15.04.2021.
//

import WidgetKit
import CoreLocation
import SwiftUI

struct Provider: TimelineProvider {
    
    typealias Entry = AirNOWEntry
    
    var widgetLocation = WidgetLocationManager()
        
    func placeholder(in context: Context) -> AirNOWEntry {
        AirNOWEntry.mockEntry()
    }
    
    
    // Показується коли ми додаємо новий віджет в меню віджетів
    func getSnapshot(in context: Context, completion: @escaping (AirNOWEntry) -> ()) {
        let entry = AirNOWEntry.mockEntry()
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        widgetLocation.fetchLocation { location in
            APICallers.shared.getAllElementsFrom(coordinate: location.coordinate) { result in
                switch result {
                case .success(let model):
                    let object = ElementManager.shared.getNearest(coordinate: location.coordinate, elements: model)
                    let entry = AirNOWEntry(date: Date(), viewModel: [object])
                    
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
                    let timeLine = Timeline(entries: [entry], policy: .after(refreshDate))
                    
                    completion(timeLine)
                    
                case .failure(_):
                    let object = LUNViewModel.getMockElement(condition: .NoData)
                    let entry = AirNOWEntry(date: Date(), viewModel: [object])
                    
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
                    let timeLine = Timeline(entries: [entry], policy: .after(refreshDate))
                    
                    completion(timeLine)
                }
            }
        }
        
        
        
    }
}
