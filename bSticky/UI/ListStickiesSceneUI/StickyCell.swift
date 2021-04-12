//
//  StickyCell.swift
//  bSticky
//
//  Created by mima on 2021/02/06.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit
import QuickLookThumbnailing

final class StickyCell: UICollectionViewCell {
    
    fileprivate let padding: CGFloat = 2.0
    
    lazy var textLabel: UILabel = {
        let view = UILabel()
        //view.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.6)
        view.textAlignment = .center
        view.textColor = UIColor.label
        view.font = UIFont.systemFont(ofSize: 15)
        view.lineBreakMode = NSLineBreakMode.byWordWrapping
        view.numberOfLines = 0

        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        self.contentView.addSubview(view)
        return view
    }()

    lazy var viewButton: UIButton = {
        let button = UIButton()

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22,
                                                      weight: .bold,
                                                      scale: .medium)
         button.setImage(UIImage(systemName: "eye")?
                            .withConfiguration(imageConfig)
                             .withTintColor(UIColor.systemYellow)
                             .withRenderingMode( .alwaysOriginal)
                         , for: .normal)

        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    
    

    // MARK: - View lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
       
        self.addSubview(viewButton) // put the button on the front

        let frame = contentView.bounds.insetBy(dx: padding, dy: padding)
        textLabel.frame = frame
        imageView.frame = frame
        viewButton.frame = CGRect(x: Int(padding + 5), y: Int(frame.height - frame.height / 4),
                                  width: Int(frame.width - 10), height: Int(frame.height / 4))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
        text = nil
    }
    
    // MARK: - Setter

    var id: Int?

    var tagColor: UIColor? {
        get {
            self.backgroundColor
        }
        set {
            self.backgroundColor = newValue
        }
    }
    
    var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
            bringSubviewToFront(textLabel)
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            bringSubviewToFront(viewButton)
        }
    }
    
    let playImage = UIImage(systemName: "play")?
        .withTintColor(UIColor.white)
        .withRenderingMode(.alwaysOriginal)
    
    // MARK: - Generate thumbnail
    
    func generateThumbnail(fileName: String) {
        // TODO: Can I generate thumbnail on ListStickiesPresenter?
        image = nil
        
        guard let imageURL = BeeMediaHelper.getFileURL(contentsType: ContentsType.Image, fileName: fileName) else { return }
        
        // thumbnail generator
        let size: CGSize = CGSize(width: 211, height:  222)
        let scale = UIScreen.main.scale
        let request = QLThumbnailGenerator.Request(fileAt: imageURL, size: size, scale: scale, representationTypes: .thumbnail)
        let generator = QLThumbnailGenerator.shared
        
        generator.generateRepresentations(for: request) { (thumbnail, type, error) in
            DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    self.image = UIImage(systemName: "xmark.octagon")
                } else {
                    self.image = thumbnail?.uiImage
                }
            }
        }
    }
}
