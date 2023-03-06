//
//  CalendarView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/27/23.
//

import SwiftUI


func clockHourToTime(hour: Int) -> String{
    let period = hour <= 11 ? "am" : "pm"
    var realHour = hour % 12
    if realHour == 0{
        realHour = 12
    }
    return "\(realHour) \(period) "
}


struct dayView: View {
    var day: Date
    var notAvailable: [(Event, String)]
    var alwaysNotAvailable: [(AlwaysEvent, String)]
    let quarterHourWidth = 15
    var dayStart: Date
    init(day: Date, notAvailable: [(Event, String)], alwaysNotAvailable: [(AlwaysEvent, String)]) {
        self.day = day
        self.notAvailable = notAvailable
        self.alwaysNotAvailable = alwaysNotAvailable
        self.dayStart = Calendar.current.startOfDay(for: day)
    }
    private func isBusyOn(beginQuarter: Date, )
    private func isBusy(quarterNumber: Int) -> Bool{
        // get begining of the day
        let beginQuarter = self.dayStart.advanced(by: 15*60*TimeInterval(quarterNumber))
        for (event, _) in self.notAvailable {
            if beginQuarter >= event.start && beginQuarter <= event.start.advanced(by: event.duration) {
                return true
            }
        }
        
        return false
    }
    
    var body: some View {
        ScrollViewReader{ scrollView in
            ScrollView(.vertical) {
                ZStack(alignment: .top) {
                    Rectangle()
                        .opacity(0.2)
                    VStack(spacing: 0){
                        Spacer(minLength: 13)
                        ForEach(1..<25, id: \.self ){hour in
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
                    ZStack(alignment: .topLeading){
                        ForEach(self.notAvailable, id: \.self.0){when, howLong in
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(.red).opacity(0.4))
                                .frame(height: CGFloat(7.5 *  howLong / (15 * 60)))
                                .offset(x: 0, y: 7.5*CGFloat(when.timeIntervalSince(self.dayStart) / (15*60) ))
                        }.padding(.horizontal, 50)
                    }.padding(10)
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .clipped()
            }
            
            
        }
        
    }
}

class DayObject: ObservableObject {
    @Published var day: Date = Date.now
}

// struct from https://gist.github.com/beader/e1312aa5b88af30407bde407235fbe67
struct InfiniteTabPageView: View {
    @GestureState private var translation: CGFloat = .zero
    @State private var currentPage: Int = 0
    @State private var offset: CGFloat = .zero
    @ObservedObject var dayObject: DayObject
    @ObservedObject var calendarVM = CalenderViewModel()
    private let width: CGFloat
    private let animationDuration: CGFloat = 0.25
    
    init(day: DayObject, width: CGFloat = 390) {
        self.width = width
        self.dayObject = day
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
                dayView(day: self.dayObject.day.advanced(by: -24 * 3600), notAvailable: calendarVM.busyTimes)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(x: CGFloat(-width))
                    .onAppear {
                        print("-1")
                    }
            }
            dayView(day: self.dayObject.day)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: CGFloat(0))
                .onAppear {
                    print("0")
                }

            dayView(day: self.dayObject.day.advanced(by: 24 * 3600))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: CGFloat(width))
                .onAppear {
                    print("1")
                }
        }
        .contentShape(Rectangle())
        .offset(x: translation)
        .offset(x: offset)
        .gesture(dragGesture)
        .clipped()
    }
    
    private func pageIndex(_ x: Int) -> Int {

        Int((CGFloat(x) / 3).rounded(.down)) * 3
    }
    
    
    private func offsetIndex(_ x: Int) -> Int {
        if x >= 0 {
            return x % 3
        } else {
            return (x + 1) % 3 + 2
        }
    }
}

struct CalendarView: View {
    @ObservedObject var dayObject = DayObject()
    var body: some View {
        VStack {
            DatePicker( "Schedule for: ", selection: $dayObject.day, displayedComponents: [.date])
            InfiniteTabPageView(day: dayObject)
            Rectangle()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
