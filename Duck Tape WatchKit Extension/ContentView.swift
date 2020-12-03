//
//  ContentView.swift
//  Duck Tape WatchKit Extension
//
//  Created by Ricardo Abreu on 02/12/2020.
//

import SwiftUI

struct ContentView: View {
    @State  var distance: Double = 0
    
    var body: some View {
        VStack{
            Text("Hello, World!")
                .padding()
            Text("\(distance)")
                .padding()
        }.onAppear{
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                
                DispatchQueue.main.async {
                    let tracker = Tracker()
                    
                    tracker.startTrackingSteps(callback: {value in
                        self.distance = value
                    })
                    
                   
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
