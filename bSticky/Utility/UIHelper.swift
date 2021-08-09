//
//  UIHelper.swift
//  bSticky
//
//  - UIColor hex converter
//
//  Created by mima on 21/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

// MARK: - UIColor hex converter
extension UIColor {
    // src: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-value
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.removeFirst() }
        
        if ((cString.count) != 6) {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
        /* Usage
         UIColor("#ff0000") // with #
         UIColor("ff0000")  // without #
         UIColor("ff0000", alpha: 0.5) // using optional alpha value
         */
    }
    
    
    var toHex: String? {
        return toHex()
    }
    
    func toHex(alpha: Bool = false) -> String? {
        // src: https://cocoacasts.com/from-hex-to-uicolor-and-back-in-swif
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
}

// MARK: - Image view round corner

extension UIImage{
    // src: https://medium.com/@ahmedmuslimani609/rounded-corner-images-and-why-it-kills-your-app-248750884379
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 50
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

// MARK: - Date formatter

struct BeeDateFormatter {
    static func convertDate(since1970: Int, withHouraAndMinutes: Bool = false) -> String {
        let time = Date(timeIntervalSince1970: TimeInterval(since1970))
        
        let dateFormatter_v2 = DateFormatter()
        
        if withHouraAndMinutes {
            dateFormatter_v2.dateFormat = "MMM dd,yyyy |h:mm a|"
        } else {
            dateFormatter_v2.dateFormat = "MMM dd,yyyy"
        }
        let date = dateFormatter_v2.string(from: time)

        return date
    }
}


// MARK: - Orientaion lock

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        /*
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // only portrait
            AppUtility.lockOrientation(.portrait)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // release rotation lock
            AppUtility.lockOrientation(.allButUpsideDown)
        }
        */   }
}


