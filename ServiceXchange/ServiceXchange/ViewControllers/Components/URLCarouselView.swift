//
//  ImageCarouselView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/11/23.
//

import SwiftUI
import Kingfisher

struct URLCarouselView: View {
    var urls: [String]
    @State private var index: Int = 0
    @State private var dragging = false
    @State private var scroll_opacity = 1.0
    @State private var jobs = [DispatchWorkItem]()
    
    let activeOpacity = 1.0
    let minOpacity = 0.51
    let hideTimeSeconds = 1.5
    let defaultHideTimeSeconds = 5.0
    let scrollbarHeight = 18.0
    
    //create a scrollbar, for the caruosel
    // if you want a horizontal scrollbar you need
    // index dragging scoll_opacity jobs as state vars
    private func scrollbar() -> some View {
        GeometryReader { geometry in
            ZStack{
                HStack(spacing: 0){
                    ForEach(0..<self.urls.count, id: \.self) { idx in
                        Button(action: {index = idx}, label: { //for snapping scrollbar to location
                            Rectangle().opacity(0)
                        })
                    }
                }
                let scrollbar_width = geometry.size.width / CGFloat(self.urls.count)
                Rectangle()
                    .foregroundColor(CustomColor.sxcgreen)
                    .cornerRadius(.infinity)
                    .frame(width: scrollbar_width)
                    .position(x: scrollbar_width * (CGFloat(index) + 0.5), y: 9)
                    .animation(Animation.linear(duration: 0.25), value: index)
                    .gesture( //add scroll behavior to green part
                        DragGesture()
                            .onChanged( {v in
                                self.dragging = true
                                // set index to position / width of scrollbar
                                self.index = min(self.urls.count - 1, max(0, Int(v.location.x /  (geometry.size.width / CGFloat(self.urls.count)))))
                            })
                            .onEnded({_ in
                                self.dragging = false
                            })
                    
                    )
                    .opacity(1 * self.scroll_opacity)
                    .animation(Animation.linear(duration: 0.2), value: self.scroll_opacity)
            }.background(
                Rectangle()
                    .cornerRadius(.infinity)
                    .opacity(0.3 * self.scroll_opacity)
                    .animation(Animation.linear(duration: 0.2), value: self.scroll_opacity)

            )
            
        }
        .frame(height: self.scrollbarHeight)
        .padding(.horizontal)
    }
    
    private func image_slider() -> some View {
        ZStack(alignment: .bottom) {
            SwiftUI.TabView(selection: $index, content: {
                ForEach(0..<urls.count, id: \.self) { idx in
                    UrlImage(url: self.urls[idx])
                }.disabled(dragging)
                
            })
                .animation(Animation.easeInOut(duration: 0.25), value: index)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            scrollbar()
        }.onChange(of: self.index, perform: { _ in
            //this function require locks, but its a best effort task anyway
            
            self.scroll_opacity = self.activeOpacity
            let scroll_hides_at = DispatchTime.now() + 1.5
            
            // cancel all previous tasks
            var prev_job = self.jobs.popLast()
            while prev_job != nil {
                prev_job!.cancel()
                prev_job = self.jobs.popLast()
            }
            let work = DispatchWorkItem {
                self.scroll_opacity = self.minOpacity
            }
            //add new task
            self.jobs.append(work)
            DispatchQueue.main.asyncAfter(deadline: scroll_hides_at, execute: work)
            
        }).onAppear(perform: {
            let scroll_hides_at = DispatchTime.now() + self.defaultHideTimeSeconds
            let work = DispatchWorkItem {
                self.scroll_opacity = minOpacity
            }
            self.jobs.append(work)
            DispatchQueue.main.asyncAfter(deadline: scroll_hides_at, execute: work)
        })
    }
    
    var body: some View {
        if urls.count > 1 {
            NavigationView {
                image_slider()
            }
        }
        else if urls.count == 1 {
            UrlImage(url: urls[0])
        }
        else {
            
        }
    }
}

struct URLCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        URLCarouselView(urls:[
            "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/1TOXMnwd2sCdpkeI77QN.jpg?alt=media&token=330f2014-13c3-4193-9e40-cd308e5af08d",
              "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/Ai4n1oLYxObolvPBFl7u.jpg?alt=media&token=fce91b18-05f4-4d1a-865e-fd296605c37e",
            "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/1TOXMnwd2sCdpkeI77QN.jpg?alt=media&token=330f2014-13c3-4193-9e40-cd308e5af08d",
            "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/1TOXMnwd2sCdpkeI77QN.jpg?alt=media&token=330f2014-13c3-4193-9e40-cd308e5af08d"
        ])
        .frame(maxHeight: 300)
    }
}
