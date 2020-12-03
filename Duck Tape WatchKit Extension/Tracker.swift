//
//  Tracker.swift
//  Duck Tape WatchKit Extension
//
//  Created by Ricardo Abreu on 02/12/2020.
//

import Foundation
import CoreMotion

// Based on https://medium.com/flawless-app-stories/swiftui-understanding-state-8afa23fd9f1f

class Tracker {
    private let pedometer = CMPedometer()
    public let motionManager = CMMotionManager()
    
    public var startDate: Date?          = nil
    public var timeElapsed:TimeInterval              = 0.2
    public var numberOfSteps:Int!                    = 0
    public var distance:Double!                      = 0.0
    public var pace:Double!                          = 0.0
    public var averagePace:Double!                   = 0.0
    public var floorsAscended:Int!                   = 0
    public var floorsDscended:Int!                   = 0
    public var cadence:Double!                       = 0
    
    
    
    /// check if steps count is available in device or not
    var isStepCountingAvailable : Bool{
        get{
            return CMPedometer.isStepCountingAvailable()
        }
    }
    /// check if pace is available in device or not
    var isPaceAvailable : Bool{
        get{
            return CMPedometer.isPaceAvailable()
        }
    }
    /// check if distance is available in device or not
    var isDistanceAvailable : Bool{
        get{
            return CMPedometer.isDistanceAvailable()
        }
    }
    var isCadenceAvailable : Bool{
        get{
            return CMPedometer.isCadenceAvailable()
        }
    }
    /// check if floor count is available in device or not
    var isFloorCountingAvailable : Bool{
        get{
            return CMPedometer.isFloorCountingAvailable()
        }
    }
    
    private func checkAuthorizationStatus() -> Bool{
        var pedoMeterAuthorized = false
        switch CMPedometer.authorizationStatus() {
        case .denied:
            return false
        case .authorized: pedoMeterAuthorized = true
        default: break
        }
        return pedoMeterAuthorized
    }
    
    
    private var stepsCountingHandler: ((_ steps: Int, _ distance: Double,   _ averagePace : Double, _ pace : Double, _ floorsAscended : Int , _ floorsDscended : Int, _ cadence : Double, _ timeElapsed : Int ) -> Void)?
    
    
    public func startTrackingSteps(callback:  @escaping  (Double)->Void) {
        motionManager.startAccelerometerUpdates(to: .main, withHandler: { (cmData, err) in
            print(cmData)
            print(err)
        })

        
        self.pedometer.startUpdates(from: Date(), withHandler:
                                        { (pedometerData, error) in
                                            if let pedData = pedometerData{
                                                
                                                if let distancee = pedData.distance{
                                                    callback(Double(truncating: distancee))
                                                }
                                                
                                                self.setPedometerData(pedData: pedData)
                                                if self.stepsCountingHandler != nil
                                                {
                                                    self.stepsCountingHandler?(self.numberOfSteps,          self.distance, self.averagePace, self.pace, self.floorsAscended, self.floorsDscended, self.cadence , Int(Date().timeIntervalSince(self.startDate!)))
                                                }
                                            } else {
                                                self.numberOfSteps = nil
                                            }
                                        })
    }
    
    
    private func setPedometerData(pedData: CMPedometerData)
    {
        self.numberOfSteps = Int(truncating: pedData.numberOfSteps)
        if let distancee = pedData.distance{
            self.distance = Double(truncating: distancee)
        }
        if let averageActivePace = pedData.averageActivePace {
            self.averagePace = Double(truncating: averageActivePace)
        }
        if let currentPace = pedData.currentPace {
            self.pace = Double(truncating: currentPace)
        }
        if let floor = pedData.floorsAscended {
            self.floorsAscended = Int(truncating: floor)
        }
        if let floor = pedData.floorsDescended {
            self.floorsDscended = Int(truncating: floor)
        }
        if let cadence = pedData.currentCadence {
            self.cadence = Double(truncating: cadence)
        }
    }
    
}
