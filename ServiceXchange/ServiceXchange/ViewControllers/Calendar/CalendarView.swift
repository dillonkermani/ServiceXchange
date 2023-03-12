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
    private let quarterHourHeight = CGFloat(7.5)
    private let halfHourHeight = CGFloat(15)
    private let seperatorHeight = CGFloat(2)
    private let busyColor = Color(red: 0.95, green: 0.3, blue: 0.3)
    private let busyInset = CGFloat(50)
    private let quarterHour = CGFloat(15*60)
    private let backgroundColor = Color(hue: 0.0, saturation: 0.0, brightness: 0.9)
    private func isConflict(time: Date, event: Event?) -> Bool {
        guard let event = event else {
            return false
        }
        return time >= event.start && time <= event.start.advanced(by: event.duration)
    }
    
    private func calculateRectOffset(start: Date, dayStart: Date) -> CGFloat {
        let rectangleOffset = quarterHourHeight * CGFloat(start.timeIntervalSince(dayStart)) / self.quarterHour
        return max(0,min(rectangleOffset, quarterHourHeight * 4 * 24))
    }
    
    private func calculateRectHeight(duration: CGFloat, offset: CGFloat) -> CGFloat {
        var res = min(CGFloat( quarterHourHeight * duration / self.quarterHour), quarterHourHeight * 4 * 24 )
        if res + offset > quarterHourHeight * 4 * 24 {
            res = max(quarterHourHeight * 4 * 24 - offset, 0)
        }
        return min(res, quarterHourHeight * 24 * 4)
    }
    private func busyOverlayView() -> some View {
        let dayStart = Calendar.current.startOfDay(for: self.day)
        return ZStack(alignment: .topLeading) {
            ForEach(self.notAvailable, id: \.self.0) { event , _  in
                let rectangleOffset = calculateRectOffset(start: event.start, dayStart: dayStart)
                let rectangleHeight = calculateRectHeight(duration: event.duration, offset: rectangleOffset)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor( busyColor )
                    .frame(height: rectangleHeight )
                    .offset(x: 0, y:  rectangleOffset  )
            }.padding(.horizontal, busyInset)
            ForEach(self.alwaysNotAvailable.compactMap({(e, id) in
                return e.getFor(day: day)
            }), id: \.self) { event in
                
                let rectangleOffset = calculateRectOffset(start: event.start, dayStart: dayStart)
                let rectangleHeight = calculateRectHeight(duration: event.duration, offset: rectangleOffset)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor( busyColor )
                    .frame(height: rectangleHeight)
                    .offset(x: 0, y: rectangleOffset)
            }.padding(.horizontal, busyInset)
        }.padding(10)
    }
    
    var body: some View {
        ScrollViewReader{ scrollView in
            ScrollView(.vertical) {
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor( backgroundColor )
                    VStack(spacing: 0){
                        Spacer(minLength: halfHourHeight - 2)
                        ForEach(1..<25, id: \.self ){ hour in
                            Rectangle()
                                .frame(height: seperatorHeight)
                                .opacity(0.3)
                            Spacer(minLength: halfHourHeight - seperatorHeight)
                            HStack(spacing: 0) {
                                Text(clockHourToTime(hour: hour))
                                    .fontWidth(.condensed)
                                Rectangle()
                                    .frame(height: seperatorHeight)
                            }.frame(height: seperatorHeight).padding(0)
                            if(hour != 24){
                                Spacer(minLength: halfHourHeight - seperatorHeight)
                            }
                        }
                    }.padding(10)
                    
                    busyOverlayView()
                    
                }.clipShape(RoundedRectangle(cornerRadius: 20))
                    .clipped()
                
            }.clipShape(RoundedRectangle(cornerRadius: 20))
                .clipped()
        
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
    @State private var width: CGFloat = UIScreen.main.bounds.width
    private let animationDuration: CGFloat = 0.25
    private let dayinSeconds = TimeInterval(24*3600)
    init(user: String, day: DayObject) {
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
                        self.dayObject.day.addTimeInterval(dayinSeconds)

                    } else if offset > 0 {
                        self.dayObject.day.addTimeInterval(-dayinSeconds)
                    }
                    offset = 0
                }
            }
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if self.dayObject.day > Date.now.advanced(by: dayinSeconds - 1.0) {
                    dayView(day: self.dayObject.day.advanced(by: -dayinSeconds), notAvailable: $calendarVM.busyTimes, alwaysNotAvailable: $calendarVM.alwaysBusyTimes)
                        .offset(x: CGFloat(-width))
                }
                dayView(day: self.dayObject.day, notAvailable: $calendarVM.busyTimes, alwaysNotAvailable: $calendarVM.alwaysBusyTimes)
                    .offset(x: CGFloat(0))
                
                
                dayView(day: self.dayObject.day.advanced(by: dayinSeconds), notAvailable: $calendarVM.busyTimes, alwaysNotAvailable: $calendarVM.alwaysBusyTimes)
                    .offset(x: CGFloat(width))
                
            }
            .contentShape(Rectangle())
            .offset(x: translation)
            .offset(x: offset)
            .gesture(dragGesture)
            .clipped()
            .task {
                self.width = reader.size.width
                await self.calendarVM.loadTimes(forUserId: user, after: Calendar.current.startOfDay(for: Date.now))
            }
        }
    }
}

struct CalendarView: View {
    let forUser: String
    @ObservedObject private var dayObject = DayObject()
    var body: some View {
        VStack {
            DatePicker("Schedule for: ",
                       selection: $dayObject.day,
                       in: Date.now...Date.distantFuture,
                       displayedComponents: [.date])
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
