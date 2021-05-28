//
//  Provider.swift
//  AQIIndexWidgetExtension
//
//  Created by Віктор Бережницький on 15.04.2021.
//

import WidgetKit
import CoreLocation
import SwiftUI

struct Provider: TimelineProvider {
    
    typealias Entry = AQIIndexEntry
    
    var widgetLocation = WidgetLocationManager()
        
    func placeholder(in context: Context) -> AQIIndexEntry {
        AQIIndexEntry.mockEntry()
    }
    
    
    // Показується коли ми додаємо новий віджет в меню віджетів
    func getSnapshot(in context: Context, completion: @escaping (AQIIndexEntry) -> ()) {
        let entry = AQIIndexEntry.mockEntry()
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        widgetLocation.fetchLocation { location in
            APICallers.shared.getAllElementsFrom(coordinate: location.coordinate) { result in
                switch result {
                case .success(let model):
                    let object = ElementManager.shared.getNearest(coordinate: location.coordinate, elements: model)
                    let entry = AQIIndexEntry(date: Date(), viewModel: [object])
                    
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
                    let timeLine = Timeline(entries: [entry], policy: .after(refreshDate))
                    
                    completion(timeLine)
                    
                case .failure(_):
                    let object = AQIIndexViewModel.getMockElement(condition: .NoData)
                    let entry = AQIIndexEntry(date: Date(), viewModel: [object])
                    
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
                    let timeLine = Timeline(entries: [entry], policy: .after(refreshDate))
                    
                    completion(timeLine)
                }
            }
        }
        
        
        
    }
}
