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
        do {
            print("\(after.timeIntervalSince1970)")
            let userRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: forUserId)
            async let busyTimesRefFuture = userRef.collection("busyTimes")
                .getDocuments()
            async let alwaysBusyTimesRefFuture = userRef.collection("alwaysBusyTimes").getDocuments()
            
            let (busyTimes, alwaysBusyTimes) = try await (busyTimesRefFuture, alwaysBusyTimesRefFuture)
            
            var busyTimesArr: [(Event, String)] = []
            var alwaysBusyTimesArr: [(AlwaysEvent, String)] = []
            print("\(busyTimes.count)")
            for busyTime in busyTimes.documents {
                let btDict = busyTime.data()
                guard let event = try? Event.init(fromDictionary: btDict) else {
                    print("check firebase data")
                    continue
                }
                busyTimesArr.append( (event, busyTime.documentID) )
            }
            for alwaysBusyTime in alwaysBusyTimes.documents {
                let abtDict = alwaysBusyTime.data()
                guard let event = try? AlwaysEvent.init(fromDictionary: abtDict) else {
                    print("check firebase data")
                    continue
                }
                alwaysBusyTimesArr.append( (event, alwaysBusyTime.documentID) )
            }
            self.busyTimes = busyTimesArr
            self.alwaysBusyTimes = alwaysBusyTimesArr
        }
        catch {
            print("couldn't load \(forUserId)'s availability")
            exit(1)
        }
    }
    
    func addBusyTime(when: Event ) async {
        
    }
    func addAlwaysBusyTime() async {
        
    }
    
    
}
