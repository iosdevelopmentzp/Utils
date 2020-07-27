//
//  LoggerCell.swift
//  DebugLogger
//
//  Created by 6 on 23.07.2020.
//  Copyright © 2020 6. All rights reserved.
//

import UIKit

internal final class LoggerCell: UITableViewCell {
    
    private let vStackView = UIStackView()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    private let hashtagLabel = UILabel()
    private let contentBackgroundView = UIView()
    private let loggerTypeLabel = UILabel()
    private let loggerTypeSeparator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let contentPadding = CGFloat(16)
        
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        loggerTypeSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(vStackView)
        NSLayoutConstraint.activate([
            vStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -contentPadding),
            vStackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentPadding),
            vStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentPadding / 2),
            vStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentPadding / 2)
        ])
        
        let space: (CGFloat) -> UIView = { height in
            let space = UIView()
            space.translatesAutoresizingMaskIntoConstraints = false
            space.heightAnchor.constraint(equalToConstant: height).isActive = true
            return space
        }
        
        vStackView.addArrangedSubview(dateLabel)
        vStackView.addArrangedSubview(space(10))
        vStackView.addArrangedSubview(loggerTypeLabel)
        vStackView.addArrangedSubview(loggerTypeSeparator)
        vStackView.addArrangedSubview(contentLabel)
        vStackView.addArrangedSubview(space(10))
        vStackView.addArrangedSubview(hashtagLabel)
        
        contentView.addSubview(contentBackgroundView)
        contentView.sendSubviewToBack(contentBackgroundView)
        
        NSLayoutConstraint.activate([
            loggerTypeSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            contentBackgroundView.rightAnchor.constraint(equalTo: self.vStackView.rightAnchor, constant: 5),
            contentBackgroundView.leftAnchor.constraint(equalTo: self.vStackView.leftAnchor, constant: -5),
            contentBackgroundView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor),
            contentBackgroundView.bottomAnchor.constraint(equalTo: self.hashtagLabel.topAnchor)
        ])
    }
    
    private func setupView() {
        
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        selectedBackgroundView = nil
        
        vStackView.axis = .vertical
        
        dateLabel.textAlignment = .right
        dateLabel.font = UIFont.italicSystemFont(ofSize: 14)
        dateLabel.textColor = UIColor.gray
        
        contentLabel.textColor = UIColor.white
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        contentLabel.numberOfLines = 0
        
        contentBackgroundView.layer.cornerRadius = 10.0
        contentBackgroundView.backgroundColor = UIColor(red: 0.f/255.f, green: 64.f/255.f, blue: 128.f/255.f, alpha: 1.0)
        
        hashtagLabel.textColor = UIColor.blue.withAlphaComponent(0.8)
        hashtagLabel.font = UIFont.italicSystemFont(ofSize: 14)
        
        loggerTypeSeparator.backgroundColor = UIColor.white
        
        loggerTypeLabel.textColor = UIColor(red: 204.f/255.f, green: 255.f/255.f, blue: 255.f/255.f, alpha: 1.0)
    }
    
    private func textColor(priority: DVDebugLoggerPriority) -> UIColor {
        switch priority {
        case .low:
            return UIColor.lightGray
        case .medium:
            return UIColor.white
        case .high:
            return UIColor(red: 153.f/255.f, green: 153.f/255.f, blue: 255.f/255.f, alpha: 1.0)
        }
    }
    
    // MARK: - Public
    
    internal func configure(logger: DVLoggerObject) {
        dateLabel.text = logger.date.debugStringRepresentation
        let hashtagMessage = logger.hashtags
            .filter { !$0.isEmpty }
            .map {
                guard String($0.prefix(1)) != "#" else { return $0 }
                return "#\($0)" }
            .joined(separator: " ")
        hashtagLabel.text = hashtagMessage.isEmpty ? nil : hashtagMessage
        contentLabel.text = logger.content
        loggerTypeLabel.text = logger.type
    }
}
