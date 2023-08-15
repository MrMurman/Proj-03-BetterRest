//
//  ContentViewML.swift
//  Proj-03-BetterRest
//
//  Created by Андрей Бородкин on 15.08.2023.
//

import SwiftUI
import CoreML

struct ContentViewML: View {
    
    @State private var wakeUP = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var showAlert = false
    
    var idealTimeCalculated: String {
        return idealTimeCalculator()
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUP, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                        .font(.headline)
                }
                
                Section {
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1..<13) {
                            Text($0 == 1 ? "\($0) cup" : "\($0) cups")
                        }
                    }
                } header: {
                    Text("Daily coffee intake")
                        .font(.headline)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text(idealTimeCalculated)
                            .font(.largeTitle)
                        Spacer()
                    }
                } header: {
                    Text("Your ideal bedtime is...")
                        .font(.headline)
                    
                }
            }
            .navigationTitle("Beter Rest")
//            .toolbar {
//                Button("Calculate", action: calculateBedTime)
//            }
//            .alert(alertTitle, isPresented: $showAlert) {
//                Button("Ok"){}
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
    
    func idealTimeCalculator() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUP)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUP - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            // something went wrong
            return "Sorry, there was a problem calculation your bedtime"
        }
        
    }
    
//    func calculateBedTime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUP)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//
//            let sleepTime = wakeUP - prediction.actualSleep
//            alertTitle = "Your ideal bedtime is..."
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//
//        } catch {
//            // something went wrong
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculation your bedtime"
//        }
//
//        showAlert = true
//    }
}

struct ContentViewML_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewML()
    }
}
