//
//  ChooseTagView.swift
//  bSticky
//
//  Created by mima on 21/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class ChooseTagView: UITableView, UITableViewDelegate {
    
    // MARK: Object lifecycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        tag = 5022
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        register(TagCell.self, forCellReuseIdentifier: "tagCell")
    }
}


// MARK: - ChooseTag view - tag cell view

class TagCell: UITableViewCell {
    
    var id: Int!
    
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        //label.backgroundColor = .systemGreen
        view.clipsToBounds = true
        return view
    }()
    
    let marker: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "heart.fill")?.withTintColor(UIColor.systemPink.withAlphaComponent(0.7)).withRenderingMode(.alwaysOriginal)
        view.isHidden = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tag Name"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDcoder: NSCoder) {
        super.init(coder: aDcoder)
    }
    
    func setup() {
        backgroundColor = .clear
        self.contentView.layer.cornerRadius = 10
        self.contentView.addSubview(colorView)
        self.contentView.addSubview(titleLabel)
        self.colorView.addSubview(marker)

        NSLayoutConstraint.activate([
            //cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -20),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            colorView.widthAnchor.constraint(equalToConstant: 60),
            colorView.heightAnchor.constraint(equalToConstant: 60),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -80),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),

            marker.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            marker.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            marker.widthAnchor.constraint(equalTo: colorView.widthAnchor, multiplier: 0.5),
            marker.heightAnchor.constraint(equalTo: colorView.heightAnchor, multiplier: 0.5)
        ])
    }
}
