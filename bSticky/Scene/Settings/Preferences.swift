//
//  Preferences.swift
//  bSticky
//
//  Created by mima on 2021/03/23.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import Foundation

class Preferences {
    
    private let defaults = UserDefaults.standard
    
    private let wallpaperKey = "wallpaper"
    
    var wallpaper: String? {
        set {
            defaults.setValue(newValue, forKey: wallpaperKey)
        }
        
        get {
            return defaults.string(forKey: wallpaperKey)
        }
    }

    class var shared: Preferences {
        struct Static {
            static let instance = Preferences()
        }
        
        return Static.instance
    }
}
