//
//  HealthKit.swift
//  swift-health-kit-poc
//
//  Created by Ricardo Monteverde on 3/1/22.
//

import HealthKit

class HealthKit {
    
    enum Status: String {
        case success
        case error
        case serviceUnavailable
        case dataTypeUnavailable
    }
    
    static let shared = HealthKit()
    
    func authorize(completion: @escaping (HealthKit.Status) -> Void) {
        
        // 1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            
            completion(.serviceUnavailable)
            return
        }
        
        // 2. Prepare the data types that will interact with HealthKit
        guard let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth) else {
                  
            completion(.dataTypeUnavailable)
            return
        }

        let toWrite: Set<HKSampleType> = [bodyMassIndex, HKObjectType.workoutType()]
        let toRead: Set<HKObjectType> = [dateOfBirth, HKObjectType.workoutType()]
        
        // 3. Request for authorization
        HKHealthStore().requestAuthorization(toShare: toWrite, read: toRead) { (authorized, error) in
            
            guard authorized else {
                if let _ = error {
                    completion(.error)
                } else {
                    completion(.error)
                }
                return
            }
            
            completion(.success)
        }
    }
}
