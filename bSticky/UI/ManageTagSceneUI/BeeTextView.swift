//
//  BeeTextView.swift
//  bSticky
//
//  Created by mima on 2021/03/11.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class BeeTextView: UITextView, UITextViewDelegate {
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder aDcoder: NSCoder) {
        super.init(coder: aDcoder)
        setup()
    }
    
    // MARK: - View lifecycle
    
    override func layoutSubviews() {
        textViewDidChange(self)
    }
    
    // MARK: - setup
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        isEditable = false
        textAlignment = .center
        isScrollEnabled = false
        layer.cornerRadius = 10
        clipsToBounds = true
        
        viewHeight = heightAnchor.constraint(equalToConstant: 60)
        viewHeight.isActive = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let sizeToFitIn = CGSize(width: self.bounds.size.width, height: CGFloat(MAXFLOAT))
        let newSize = self.sizeThatFits(sizeToFitIn)
        
        self.viewHeight.constant = newSize.height
        self.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textColor == UIColor.lightGray {
            text = nil
            textColor = UIColor.label
        }
    }
}
