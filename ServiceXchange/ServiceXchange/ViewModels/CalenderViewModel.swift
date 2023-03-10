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

public let PRIMORDIAL_DATE = Date.ReferenceType(timeIntervalSinceReferenceDate: 0) as Date

fileprivate let CALENDAR = Calendar.init(identifier: .gregorian)

fileprivate func weekStart(day: Date) -> Date? {
    return CALENDAR.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: day).date
}

struct AlwaysEvent: Encodable, Decodable, Hashable {
    var t: Date
    var duration: TimeInterval
    
    init(day: Date, duration: TimeInterval) {
        self.t = PRIMORDIAL_DATE.advanced(by: day.timeIntervalSince( weekStart(day: day)! )) //TODO: fix? idk how
        self.duration = duration
    }
    
    func getFor(day: Date) -> Event {
        let weekStartDay = weekStart(day: day) ?? day
        var nextInstance = weekStartDay.advanced(by: self.t.timeIntervalSince(PRIMORDIAL_DATE))
        let tz = TimeZone.current
        let currentOffset = tz.daylightSavingTimeOffset(for: day)
        let weekStartOffset = tz.daylightSavingTimeOffset(for: weekStartDay)
        nextInstance.addTimeInterval( weekStartOffset - currentOffset)
        return Event(start: nextInstance, duration: self.duration)
    }
}

class CalenderViewModel: ObservableObject {
    @Published var busyTimes: [(Event, String)] = []
    @Published var alwaysBusyTimes: [(AlwaysEvent, String)] = []
    
    @MainActor
    func loadTimes(forUserId: String, after: Date) async {
        do {
            let userRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: forUserId)
            async let busyTimesRefFuture = userRef.collection("busyTimes")
                .whereField("start", isGreaterThan: Calendar.current.startOfDay(for: after).timeIntervalSince1970)
                .getDocuments()
            async let alwaysBusyTimesRefFuture = userRef.collection("alwaysBusyTimes").getDocuments()
            
            let (busyTimes, alwaysBusyTimes) = try await (busyTimesRefFuture, alwaysBusyTimesRefFuture)
            
            var busyTimesArr: [(Event, String)] = []
            var alwaysBusyTimesArr: [(AlwaysEvent, String)] = []
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
            self.busyTimes.sort(by: {t1, t2 in
                return t1.0.start < t1.0.start
            })
            alwaysBusyTimesArr.sort(by: {t1, t2 in
                return t1.0.t < t1.0.t
            })
            self.busyTimes = busyTimesArr
            self.alwaysBusyTimes = alwaysBusyTimesArr
        }
        catch {
            print("couldn't load \(forUserId)'s availability")
            exit(1)
        }
    }
    
    func addBusyTime(forUserId: String, when: Event ) async -> Bool {
        do {
            let userRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: forUserId)
            let dataDict = try when.toDictionary()
            let _ = try await userRef.collection("busyTimes").addDocument(data: dataDict)
            return true
        }
        catch {
            print("error adding busy time")
            return false
        }
    }
    func addAlwaysBusyTime(forUserId: String, when: AlwaysEvent) async -> Bool {
        do {
            let userRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: forUserId)
            let dataDict = try when.toDictionary()
            let _ = try await userRef.collection("alwaysBusyTimes").addDocument(data: dataDict)
            return true
        }
        catch {
            print("error adding always busy time")
            return false
        }
    }
    func deleteEvent(forUserId: String, id: String) async {
        let userRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: forUserId)
        do {
            try await userRef.collection("busyTimes").document(id).delete()
            self.busyTimes.removeAll(where: {t in t.1 == id})
        } catch {
            print("error deleteing \(id) for \(forUserId)")
        }
    }
    func deleteAlwaysEvent(forUserId: String, id: String) async {
        let userRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: forUserId)
        do {
            try await userRef.collection("alwaysBusyTimes").document(id).delete()
            self.alwaysBusyTimes.removeAll(where: {t in t.1 == id})

        } catch {
            print("error deleteing always \(id) for \(forUserId)")
        }
    }
    
}
