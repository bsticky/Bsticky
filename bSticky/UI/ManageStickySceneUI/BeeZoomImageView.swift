//
//  BeeZoomImageView.swift
//  bSticky
//
//  Created by mima on 2021/03/05.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class BeeZoomImageView: UIScrollView, UIScrollViewDelegate {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - set up
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        minimumZoomScale = 1
        maximumZoomScale = 6
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setImage(image: UIImage) {
        self.imageView.image = nil
        self.imageView.image = image
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
