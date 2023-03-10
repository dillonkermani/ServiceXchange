//
//  CalendarEditView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 3/8/23.
//

import SwiftUI

struct CalendarEditView: View {
    let forUser: String
    @StateObject var calendarVM = CalenderViewModel()
    @State var dateSelected: Date = Date.now
    @State var endingDate: Date = Date.now.advanced(by: 3600)
    @State var isWeekly: Bool = false
    @State var uploading = false
    func uploadData() {
        if uploading {
            return
        }
        let duration = endingDate.timeIntervalSince(dateSelected)
        uploading = true

        if isWeekly {
            let event = AlwaysEvent(day: dateSelected, duration: duration)
            Task {
                _ = await calendarVM.addAlwaysBusyTime(
                    forUserId: forUser,
                    when: event)
                uploading = false
            }
            return
        }
        let event = Event(start: dateSelected, duration: duration)
        Task {
            _ = await calendarVM.addBusyTime(
                forUserId: forUser,
                when: event)
            uploading = false
        }
    }
    var body: some View {
        VStack {
            Text("I'm Busy...")
            DatePicker("Starting", selection: $dateSelected,                        in: Date.now...Date.distantFuture)
            DatePicker("Ending", selection: $endingDate, in: dateSelected...Date.distantFuture)
            Toggle("Weekly", isOn: $isWeekly)
            Button(action: self.uploadData, label: {
                Text("Add")
                    .foregroundColor(.black)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(.black, style: StrokeStyle(lineWidth: 2))
                    }
            })
            Text("One Time Events")
                .underline()
            ScrollView {
                ForEach(calendarVM.busyTimes, id: \.self.0) { event, id in
                    HStack {
                        Text("\(event.start.formatted()) - \(event.start.advanced(by: event.duration).formatted())")
                        Spacer()
                        Button(action: {
                            Task{ await calendarVM.deleteEvent(
                                forUserId: forUser, id: id
                            )}
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        })
                    }
                    Rectangle().frame(height: 2).opacity(0.5)
                }
            }
            Text("Weekly Events")
                .underline()
            ScrollView {
                ForEach(calendarVM.alwaysBusyTimes.compactMap({(e, id) in
                    return (e.getFor(day: Date.now), id)
                }), id: \.self.0) { event, id in
                    HStack {
                        Text("This week: \(event.start.formatted())")
                        Spacer()
                        Button(action: {
                            Task{ await calendarVM.deleteEvent(
                                forUserId: forUser, id: id
                            )}
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        })
                    }
                    Rectangle().frame(height: 2).opacity(0.5)
                }
            }
            
        }
        .padding()
        .task {
            await calendarVM.loadTimes(forUserId: forUser, after: Date.now)
        }
    }
}

struct CalendarEditView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CalendarEditView(forUser: "7syxwXFCwYh6HevOXCD9oTJJV7n1")
        }
    }
}
