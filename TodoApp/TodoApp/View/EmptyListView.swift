//
//  EmptyListView.swift
//  TodoApp
//
//  Created by user219285 on 4/4/23.
//

import SwiftUI

struct EmptyListView: View {
    @State private var isAnimated: Bool = false
    
    let images: [String] = [
        "illustration-no1",
        "illustration-no2",
        "illustration-no3"
    ]
    
    let tips: [String] = [
    "Use your time wisely.",
    "Slow and steady wins the race.",
    "Keep it short and sweet.",
    "Put hard task first.",
    "Reward yourself after work",
    "Collect tasks ahead of time",
    "Each night schedule for tomorrow"
    ]
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image("\(images.randomElement() ?? images[0])")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                
                Text("\(tips.randomElement() ?? tips[0])")
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            }
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : -50)
            .animation(.easeOut(duration: 1.5), value: isAnimated)
            .onAppear {
                isAnimated.toggle()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(colorBase)
        .edgesIgnoringSafeArea(.all)
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
