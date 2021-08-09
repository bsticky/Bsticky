//
//  BeeMediaManager.swift
//  bSticky
//
//  Created by mima on 2021/02/04.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit
import QuickLookThumbnailing

class BeeMediaHelper {
    // MARK: Generate file url (for image, audio file)
    static func generateNewFileURL(mediaType: MediaType) throws -> URL {
        var url: URL?
        
        // Document directory path
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        

        switch mediaType {
        case .image:
            do {
                let directoryPath = urls[urls.endIndex-1].appendingPathComponent("image")
                
                // If "/image" direcotry not exist
                if !FileManager.default.fileExists(atPath: directoryPath.path) {
                    try FileManager.default.createDirectory(atPath: directoryPath.path,
                                                            withIntermediateDirectories: false,
                                                            attributes: nil) }
                
                // File name
                let fileName = "/bs_image_" + dateFormatter.string(from: Date()).appending(mediaType.rawValue)
                
                let fullPath = directoryPath.path + fileName
                url = URL(fileURLWithPath: fullPath)

            } catch let error {
                let errorMessage = (error.localizedDescription)
                throw BeeMediaHelperError.CannotFindImageURL(errorMessage)
            }
            
        case .audio:
            do {
                let directoryPath = urls[urls.endIndex-1].appendingPathComponent("audio")
                
                // If "/audio" direcotry not exist
                if !FileManager.default.fileExists(atPath: directoryPath.path) {
                    try FileManager.default.createDirectory(atPath: directoryPath.path,
                                                            withIntermediateDirectories: false,
                                                            attributes: nil) }
                
                // File name
                let fileName = "/bs_audio_" + dateFormatter.string(from: Date()).appending(mediaType.rawValue)
                
                let fullPath = directoryPath.path + fileName
                url = URL(fileURLWithPath: fullPath)

            } catch let error {
                let errorMessage = (error.localizedDescription)
                throw BeeMediaHelperError.CannotFindImageURL(errorMessage)
            }
        }
        return url!
    }
    
    // MARK: Get exists audio URL
    static func getAudioURL(fileName: String) -> URL! {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directoryPath = urls[urls.endIndex-1].appendingPathComponent("audio")
        let audioURL = directoryPath.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: audioURL.path) {
            let url = URL(fileURLWithPath: audioURL.path)
            return url
        } else {
            return nil
        }
    }
    
    static func getFileURL(contentsType: ContentsType, fileName: String) -> URL! {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url: URL? = nil
        
        switch contentsType {
        case .Image:
            let directoryPath = urls[urls.endIndex-1].appendingPathComponent("image")
            url = directoryPath.appendingPathComponent(fileName)
        case .Audio:
            let directoryPath = urls[urls.endIndex-1].appendingPathComponent("audio")
            url = directoryPath.appendingPathComponent(fileName)
        default:
            break
        }
        
        if FileManager.default.fileExists(atPath: url!.path) {
            let url = URL(fileURLWithPath: url!.path)
            return url
        } else {
            return nil
        }
    }

    static func getImage(fileName: String) -> UIImage! {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directoryPath = urls[urls.endIndex-1].appendingPathComponent("image")
        let imageURL = directoryPath.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: imageURL.path) {
            return UIImage(contentsOfFile: imageURL.path)
        } else {
            return nil
        }
    }
    
    // MARK: Delete file
    static func deleteFile(fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Bee media helepr successfully delete file")
        } catch let error {
            print("Error cusec \(error)")
            // handle error
            return
        }
    }
    
    // MARK: Camera permission alert
    static func getCameraPermissionAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "", message: "Please allow access to the camera in the device's settings -> Privacy -> Camera", preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK", style: .default, handler: { (alert: UIAlertAction!) in if UIApplication.shared.canOpenURL( URL(string: UIApplication.openSettingsURLString)!) { UIApplication.shared.openURL( URL(string: UIApplication.openSettingsURLString)!) } })

        let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    // MARK: Draw Wallpaper
    static func getWallpaper(size: CGSize, bounds: CGRect) -> UIImage! {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[urls.endIndex-1].appendingPathComponent("wallpaper.jpg")
        
        if FileManager.default.fileExists(atPath: url.path) {
            UIGraphicsBeginImageContext(size)
            UIImage(contentsOfFile: url.path)?.draw(in: bounds)
            let bg: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return bg
        } else {
            return nil
        }
    }

    // MARK: - Media type
    enum MediaType: String {
        case image = ".jpg"
        case audio = ".m4a"
    }
    
    // MARK: - Error
    enum BeeMediaHelperError: Error {
        case CannotFindImageURL(String)
        case CannotFindaudioURL(String)
        case CannotFindImageFile(String)
    }
    
}

