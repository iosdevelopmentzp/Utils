//
//  DebugLoggerToolView.swift
//  DebugLogger
//
//  Created by 6 on 23.07.2020.
//  Copyright © 2020 6. All rights reserved.
//

import UIKit

internal final class DebugLoggerToolView: UIView {
    
    private let hStackView = UIStackView()
    private let searchBar = UISearchBar()
    private let filterButton = UIButton()
    private let filterButtonContent = UIView()
    private let menuButton = UIButton()
    private let menuButtonContent = UIView()
    private let filterSign = RoundedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstarints()
        setupView()
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstarints() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.filterButton.translatesAutoresizingMaskIntoConstraints = false
        self.filterButtonContent.translatesAutoresizingMaskIntoConstraints = false
        self.menuButton.translatesAutoresizingMaskIntoConstraints = false
        self.menuButtonContent.translatesAutoresizingMaskIntoConstraints = false
        self.hStackView.translatesAutoresizingMaskIntoConstraints = false
        self.filterSign.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            hStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            hStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hStackView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        hStackView.addArrangedSubview(searchBar)
        hStackView.addArrangedSubview(filterButtonContent)
        hStackView.addArrangedSubview(menuButtonContent)
        
        filterButtonContent.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.widthAnchor.constraint(equalToConstant: 24),
            filterButton.heightAnchor.constraint(equalToConstant: 24),
            filterButton.centerYAnchor.constraint(equalTo: self.filterButtonContent.centerYAnchor),
            filterButton.centerXAnchor.constraint(equalTo: self.filterButtonContent.centerXAnchor),
            filterButtonContent.widthAnchor.constraint(equalTo: self.filterButton.widthAnchor, multiplier: 1.4)
        ])
        
        menuButtonContent.addSubview(menuButton)
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 24),
            menuButton.heightAnchor.constraint(equalToConstant: 24),
            menuButton.centerYAnchor.constraint(equalTo: self.menuButtonContent.centerYAnchor),
            menuButton.centerXAnchor.constraint(equalTo: self.menuButtonContent.centerXAnchor),
            menuButtonContent.widthAnchor.constraint(equalTo: self.menuButton.widthAnchor, multiplier: 1.4)
        ])

        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(filterSign)
        
        NSLayoutConstraint.activate([
            self.filterSign.topAnchor.constraint(equalTo: self.filterButton.topAnchor, constant: -2.0),
            self.filterSign.rightAnchor.constraint(equalTo: self.filterButton.rightAnchor, constant: 2.0),
            self.filterSign.heightAnchor.constraint(equalToConstant: 12.0),
            self.filterSign.widthAnchor.constraint(equalToConstant: 12.0)
        ])
    }
    
    private func setupView() {
        self.backgroundColor =  UIColor(red: 245.f/255.f, green: 245.f/255.f, blue: 245.f/255.f, alpha: 1.0)
        
        self.searchBar.backgroundColor =  UIColor(red: 245.f/255.f, green: 245.f/255.f, blue: 245.f/255.f, alpha: 1.0)
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.tintColor = UIColor.black
        let searchTextField = (self.searchBar.value(forKey: "searchField") as? UITextField)
        searchTextField?.textColor = UIColor.black
        searchTextField?.autocapitalizationType = .none
        searchTextField?.autocorrectionType = .no
        
        self.filterButton.contentVerticalAlignment = .fill
        self.filterButton.contentHorizontalAlignment = .fill
        self.filterButton.setImage(UIImage(named: "filter"), for: .normal)
        self.menuButton.setImage(UIImage(named: "menu"), for: .normal)
        
        hStackView.axis = .horizontal
        
        self.filterSign.backgroundColor = UIColor.red
        self.filterSign.isHidden = self.filterSignIsHidden
    }
    
    private func binding() {
        self.filterButton.addTarget(self, action: #selector(self.tappedFilterButton(sender:)), for: .touchUpInside)
        self.menuButton.addTarget(self, action: #selector(self.tappedMenuButton(sender:)), for: .touchUpInside)
    }
    
    
    // MARK: - User interaction
    
    @objc private func tappedMenuButton(sender: UIButton) {
        menuAction?()
    }
    
    @objc private func tappedFilterButton(sender: UIButton) {
        filterAction?()
    }
    
    // MARK: - Public
    
    var menuAction: (() -> Void)?
    var filterAction: (() -> Void)?
    
    var filterSignIsHidden: Bool = true {
        didSet {
            self.filterSign.isHidden = filterSignIsHidden
        }
    }
    
    var searchDelegate: UISearchBarDelegate? {
        set { self.searchBar.delegate = newValue }
        get { return self.searchBar.delegate }
    }
}

private final class RoundedView: UIView {
    
    override var bounds: CGRect {
        didSet {
            self.layer.cornerRadius = self.bounds.height / 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
