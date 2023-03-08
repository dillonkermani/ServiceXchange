//
//  CalendarView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/27/23.
//

import SwiftUI


fileprivate func clockHourToTime(hour: Int) -> String{
    let period = hour <= 11 ? "am" : "pm"
    var realHour = hour % 12
    if realHour == 0{
        realHour = 12
    }
    return "\(realHour) \(period) "
}


fileprivate struct dayView: View {
    var day: Date
    @Binding var notAvailable: [(Event, String)]
    @Binding var alwaysNotAvailable: [(AlwaysEvent, String)]
    let quarterHourWidth = 15
    private func isConflict(time: Date, event: Event?) -> Bool {
        guard let event = event else {
            return false
        }
        return time >= event.start && time <= event.start.advanced(by: event.duration)
    }
    
    var body: some View {
        ScrollViewReader{ scrollView in
            ScrollView(.vertical) {
                ZStack(alignment: .top) {
                    Rectangle()
                        .opacity(0.2)
                    VStack(spacing: 0){
                        Spacer(minLength: 13)
                        ForEach(1..<25, id: \.self ){ hour in
                            Rectangle()
                                .frame(height: 2)
                                .opacity(0.3)
                            Spacer(minLength: 13)
                            HStack(spacing: 0) {
                                Text(clockHourToTime(hour: hour))
                                    .fontWidth(.condensed)
                                Rectangle()
                                    .frame(height: 2)
                            }.frame(height: 2).padding(0)
                            if(hour != 24){
                                Spacer(minLength: 13)
                            }
                        }
                    }.padding(10)
                    ZStack(alignment: .topLeading) {
                        let dayStart = Calendar.current.startOfDay(for: self.day)
                        ForEach(self.notAvailable, id: \.self.0) { event , _  in
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(.red).opacity(0.4))
                                .frame(height: CGFloat(7.5 * event.duration / (15 * 60)))
                                .offset(x: 0, y: 7.5*CGFloat(event.start.timeIntervalSince(dayStart) / (15*60) ))
                                .onAppear() {
                                    print(event.start)
                                    let f = (7.5*CGFloat(event.start.timeIntervalSince(dayStart) / (15*60)))
                                    print("\(f)")
                                }
                        }.padding(.horizontal, 50)
                    }.padding(10)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .clipped()
            }
        
        }
    }
}

fileprivate class DayObject: ObservableObject {
    @Published var day: Date = Date.now
}

// struct from https://gist.github.com/beader/e1312aa5b88af30407bde407235fbe67
fileprivate struct InfiniteTabPageView: View {
    let user: String
    @GestureState private var translation: CGFloat = .zero
    @State private var currentPage: Int = 0
    @State private var offset: CGFloat = .zero
    @ObservedObject var dayObject: DayObject
    @StateObject var calendarVM = CalenderViewModel()
    private let width: CGFloat
    private let animationDuration: CGFloat = 0.25
    
    init(user: String, day: DayObject, width: CGFloat = 390) {
        self.width = width
        self.dayObject = day
        self.user = user
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 25)
            .updating($translation) { value, state, _ in
                let translation = min(width, max(-width, value.translation.width))
                state = translation
            }
            .onEnded { value in
                offset = min(width, max(-width, value.translation.width))

                if value.translation.width > 0 && self.dayObject.day <= Date.now {
                    withAnimation(.easeOut(duration: animationDuration)) {
                        offset = 0
                    }
                    return
                }
                let predictEndOffset = value.predictedEndTranslation.width
                withAnimation(.easeOut(duration: animationDuration)) {
                    if offset < -width / 2 || predictEndOffset < -width {
                        offset = -width
                    } else if offset > width / 2 || predictEndOffset > width {
                        offset = width
                    } else {
                        offset = 0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    if offset < 0 {
                        self.dayObject.day.addTimeInterval(24 * 60 * 60)

                    } else if offset > 0 {
                        self.dayObject.day.addTimeInterval(-24 * 60 * 60)
                    }
                    offset = 0
                }
            }
    }
    
    var body: some View {
        ZStack {
            if self.dayObject.day > Date.now.advanced(by: 23.9 * 3600) {
                dayView(day: self.dayObject.day.advanced(by: -24 * 3600), notAvailable: $calendarVM.busyTimes, alwaysNotAvailable: $calendarVM.alwaysBusyTimes)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(x: CGFloat(-width))
                }
            dayView(day: self.dayObject.day, notAvailable: $calendarVM.busyTimes, alwaysNotAvailable: $calendarVM.alwaysBusyTimes)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: CGFloat(0))
                

            dayView(day: self.dayObject.day.advanced(by: 24 * 3600), notAvailable: $calendarVM.busyTimes, alwaysNotAvailable: $calendarVM.alwaysBusyTimes)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: CGFloat(width))
                
        }
        .contentShape(Rectangle())
        .offset(x: translation)
        .offset(x: offset)
        .gesture(dragGesture)
        .clipped()
        .task {
            await self.calendarVM.loadTimes(forUserId: user, after: Calendar.current.startOfDay(for: Date.now))
        }
    }
}

struct CalendarView: View {
    let forUser: String
    @ObservedObject private var dayObject = DayObject()
    var body: some View {
        VStack {
            DatePicker( "Schedule for: ", selection: $dayObject.day, displayedComponents: [.date])
            InfiniteTabPageView(user: forUser, day: dayObject)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            CalendarView(forUser: "7syxwXFCwYh6HevOXCD9oTJJV7n1" )
            Rectangle()
        }
    }
}
