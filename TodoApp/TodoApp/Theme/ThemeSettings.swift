//
//  ThemeSettings.swift
//  TodoApp
//
//  Created by user219285 on 4/4/23.
//

import Foundation
import SwiftUI

class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme"){
        
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
    
    private init() {}
    public static let shared = ThemeSettings()
}
