//
//  SettingsView.swift
//  TodoApp
//
//  Created by user219285 on 4/4/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: IconNames
    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                //MARK: - Form
                
                Form {
                    
                    //MARK: - Section 1
                    Section("Choose the app icon") {
                        Picker(selection: $iconSettings.currentIndex, label:
                                HStack {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .strokeBorder(Color.primary, lineWidth: 2)
                                Image(systemName: "paintbrush")
                                    .font(.system(size: 28, weight: .regular, design: .default))
                                .foregroundColor(.primary)
                            }
                            .frame(width: 44, height: 44)
                            
                            Text("App Icon".uppercased())
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }) // end of label
                        {
                            ForEach(0..<iconSettings.iconNames.count, id: \.self) { index in
                                HStack {
//                                    Image(uiImage: UIImage(named: iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
//                                        .renderingMode(.original)
//                                        .scaledToFit()
//                                        .frame(width: 44, height: 44)
//                                        .cornerRadius(10)
                                
                                    Spacer().frame(width: 8)
                                    
                                    Text(self.iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                }
                                .padding(3)
                            }
                        }
                        .onReceive([self.iconSettings.currentIndex].publisher.first()) { (value) in
                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("Succes! You have changed the app icon")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 3)
                    
                    //MARK: - Section 2
                    Section(header:
                                HStack {
                                    Text("Choose the app theme")
                                    Image(systemName: "circle.fill")
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(themes[self.theme.themeSettings].themeColor)
                                }
                    
                    ) {
                        List {
                            ForEach(themes) { theme in
                                Button(action: {
                                    self.theme.themeSettings = theme.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                }) {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(theme.themeColor)
                                        Text(theme.themeName)
                                    }
                                }
                                .accentColor(.primary)
                            }
                        }
                    }
                    .padding(3)
                    
                    //MARK: - Section 3
                    Section("Follow us on social media") {
                        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: .blue, text: "Twitter", link: "https://twitter.com/robertpetras")
                        FormRowLinkView(icon: "play.rectangle", color: .green, text: "Courses", link: "https://www.udemy.com/user/robert-petras")
                    }
                    
                    //MARK: - Section 4
                    Section("About the application") {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Daria")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }
                    .padding(.vertical, 3)
                    Text("")
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                //MARK: - Footer
                Text("Copyright © All rights reserved.\nBetter Apps ♡ Less Code")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
            }
            .navigationBarItems(trailing:
                Button(action: {
                presentationMode.wrappedValue.dismiss()
                }) {
                Image(systemName: "xmark")
                }
            )
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(colorBackground.edgesIgnoringSafeArea(.all))
        }
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(IconNames())
    }
}
