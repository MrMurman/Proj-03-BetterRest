//
//  ContentView.swift
//  Proj-03-BetterRest
//
//  Created by Андрей Бородкин on 15.08.2023.
//

import SwiftUI

struct ContentViewDate: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            DatePicker("Please enter a time", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
            Text(Date.now, format: .dateTime.day().hour().minute())
            Text(Date.now.formatted(date: .long, time: .shortened))
        }
        .padding()
    }
    func exampleDate() {
        let tomorrow = Date.now.addingTimeInterval(86400)
        let range = Date.now...tomorrow
    }
    func trivialExample() {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? Date.now
        
        let components2 = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
        let hour = components2.hour ?? 0
        let minutes = components2.minute ?? 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewDate()
    }
}
