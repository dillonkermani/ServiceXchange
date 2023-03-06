//
//  CalenderViewModel.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 3/5/23.
//

import Foundation
import SwiftUI
import FirebaseCore

struct Event: Encodable, Decodable, Hashable {
    var start: Date
    var duration: TimeInterval
}

fileprivate let primordialDate = Date.ReferenceType(timeIntervalSinceReferenceDate: 0) as Date

fileprivate func weekStart(day: Date) -> Date? {
    return Calendar.init(identifier: .gregorian).dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: day).date
}

struct AlwaysEvent: Encodable, Decodable, Hashable {
    var t: Date
    var duration: TimeInterval
    
    init(day: Date, duration: TimeInterval) {
        self.t = primordialDate.advanced(by: day.timeIntervalSince( weekStart(day: day)! ))
        self.duration = duration
    }
    
    func getFor(day: Date) -> Event? {
        guard let nextInstance = weekStart(day: day)?.advanced(by: self.t.timeIntervalSince(primordialDate)) else {
            return nil
        }
        return Event(start: nextInstance, duration: self.duration)
    }
}

class CalenderViewModel: ObservableObject {
    @Published var busyTimes: [(Event, String)] = []
    @Published var alwaysBusyTimes: [(AlwaysEvent, String)] = []
    
    @MainActor
    func loadTimes(forUserId: String, after: Date) async {
        let availabliltyRef = Ref.FIRESTORE_ROOT.collection("availability")
        do {
            let userRef = availabliltyRef.document(forUserId)
            async let busyTimesRefFuture = userRef.collection("busyTimes")
                .whereField("start", isGreaterThan: after).getDocuments()
            async let alwaysBusyTimesRefFuture = userRef.collection("alwaysBusyTimes").getDocuments()
            
            let (busyTimes, alwaysBusyTimes) = try await (busyTimesRefFuture, alwaysBusyTimesRefFuture)
            
            self.busyTimes = []
            self.alwaysBusyTimes = []
            for busyTime in busyTimes.documents {
                let btDict = busyTime.data()
                guard let event = try? Event.init(fromDictionary: btDict) else {
                    print("check ureserldf")
                    continue
                }
                self.busyTimes.append( (event, busyTime.documentID) )
            }
            for alwaysBusyTime in alwaysBusyTimes.documents {
                let abtDict = alwaysBusyTime.data()
                guard let event = try? AlwaysEvent.init(fromDictionary: abtDict) else {
                    print("check uirself")
                    continue
                }
                self.alwaysBusyTimes.append( (event, alwaysBusyTime.documentID) )
            }
        }
        catch {
            print("couldn't load \(forUserId)'s availability")
            return
        }
    }
    
    func addBusyTime(when: Event ) async {
        
    }
    func addAlwaysBusyTime() async {
        
    }
    
    
}
