//
//  WallpaperSettingViewController.swift
//  bSticky
//
//  Created by mima on 2021/03/21.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class AppreanceSettingViewController: UIViewController {
    weak var wallpaperSettingView: AppreanceSettingView!
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // only portrait
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wallpaperSettingView = AppreanceSettingView()
        wallpaperSettingView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(wallpaperSettingView)
        self.wallpaperSettingView = wallpaperSettingView
        
        // set nav bar
        let navItem = UINavigationItem(title: "Appreance")
        
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(navDoneButtonTapped(_:)))
        
        navItem.setLeftBarButton(doneButton, animated: true)
        wallpaperSettingView.navBar.setItems([navItem], animated: true)
        
        // set wallpaper menu
        let wallpaperMenu = SettingMenuSection()
        wallpaperMenu.titleLabel.text = "Set wallpaper"

        let choseFromPhotos = SettingMenuBar()
        choseFromPhotos.setMenu(iconName: "photo.on.rectangle.angled", title: "Choose from Photos")
        choseFromPhotos.arrowButton.addTarget(self, action: #selector(choseFromPhotosTapped(_:)), for: .touchUpInside)
        
        let choseFromColorPicker = SettingMenuBar()
        choseFromColorPicker.arrowButton.addTarget(self, action: #selector(choseFromColorPickerTapped(_:)), for: .touchUpInside)
        choseFromColorPicker.setMenu(iconName: "eyedropper.halffull", title: "Choose from ColorPicker")
        
        wallpaperMenu.addArrangedSubview(choseFromPhotos)
        wallpaperMenu.addArrangedSubview(choseFromColorPicker)
        
        wallpaperSettingView.menuStackView.addArrangedSubview(wallpaperMenu)

        // set constraints
        NSLayoutConstraint.activate([
            wallpaperSettingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wallpaperSettingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wallpaperSettingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            wallpaperSettingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setWallpaper()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // release orientation lock
        AppUtility.lockOrientation(.allButUpsideDown)
    }
    
    @objc func navDoneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func choseFromPhotosTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        DispatchQueue.main.async {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            }
    }

    @objc func choseFromColorPickerTapped(_ sender: Any) {
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            
            DispatchQueue.main.async {
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setWallpaper() {
        guard let wallpaper = Preferences.shared.wallpaper else {
            return
        }
        
        if wallpaper.hasSuffix(".jpg") {
            let size = wallpaperSettingView.wallpaperPreview.frame.size
            let bounds = self.wallpaperSettingView.wallpaperPreview.bounds
            
            guard let bg = BeeMediaHelper.getWallpaper(size: size, bounds: bounds) else {
                return
            }
            self.wallpaperSettingView.wallpaperPreview.backgroundColor = UIColor(patternImage: bg)
        } else {
            self.wallpaperSettingView.wallpaperPreview.backgroundColor = UIColor(wallpaper)
        }
    }
    
    func saveWallpaperImage(image: UIImage) {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[urls.endIndex-1].appendingPathComponent("wallpaper.jpg")
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: url)
                Preferences.shared.wallpaper = "wallpaper.jpg"
            } catch {
                // TODO : write debug log
                print("Error: saveWallpaperImage")
            }
        }
    }
}

// MARK: - Image picker controller

extension AppreanceSettingViewController:  UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            saveWallpaperImage(image: pickedImage)
            // set preview
            setWallpaper()
        }
        dismiss(animated: true, completion: nil)
    }
    
}
// MARK: - Color picker controller

@available(iOS 14.0, *)
extension AppreanceSettingViewController: UIColorPickerViewControllerDelegate {
    @objc func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    }
    
    @objc func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        Preferences.shared.wallpaper = viewController.selectedColor.toHex
        // set preview
        setWallpaper()
    }
}
