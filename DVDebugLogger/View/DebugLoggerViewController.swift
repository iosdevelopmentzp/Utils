//
//  DebugLoggerViewController.swift
//  DebugLogger
//
//  Created by 6 on 23.07.2020.
//  Copyright © 2020 6. All rights reserved.
//

import UIKit

final internal class DebugLoggerViewController: UIViewController {
    
    private let toolView = DebugLoggerToolView()
    private let tableView = UITableView()
    private var tableViewRefreshController: UIRefreshControl?
    
    private var dataSource: [DVLoggerObject] = []
    private var isRefreshing: Bool = false
    
    // filter
    private var searchPhrases: [String] = []
    private var filteredDataSource: [DVLoggerObject] = []
    private var isFilteringState: Bool {
        return searchPhrases.count > 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupView()
        setupTableView()
        binding()
    }
    
    private func setupConstraints() {
        
        self.view.addSubview(tableView)
        self.view.addSubview(toolView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        toolView.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11.0, *) {
            let safeLayout = self.view.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                toolView.leftAnchor.constraint(equalTo: safeLayout.leftAnchor),
                toolView.rightAnchor.constraint(equalTo: safeLayout.rightAnchor),
                toolView.topAnchor.constraint(equalTo: safeLayout.topAnchor)
            ])
            
            NSLayoutConstraint.activate([
                tableView.leftAnchor.constraint(equalTo: safeLayout.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: safeLayout.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
                tableView.topAnchor.constraint(equalTo: self.toolView.bottomAnchor)
            ])
        } else {
            
            NSLayoutConstraint.activate([
                toolView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                toolView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                toolView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
            ])
            
            NSLayoutConstraint.activate([
                tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
                tableView.topAnchor.constraint(equalTo: self.toolView.bottomAnchor)
            ])
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.white
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(LoggerCell.self, forCellReuseIdentifier: String(describing: LoggerCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 245.f/255.f, green: 245.f/255.f, blue: 245.f/255.f, alpha: 1.0)
        setupRefreshController()
    }
    
    private func errorHandler(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func binding() {
        updateData() {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        self.toolView.searchDelegate = self
        self.toolView.menuAction = { [weak self] in
            self?.openMenuAction()
        }
    }
    
    private func updateData(sucessCompletion: (() -> Void)?) {
        self.isRefreshing = true
        DVDebug.default.getLocalLogsObjects { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.isRefreshing = false
                self?.tableViewRefreshController?.endRefreshing()
            }
            switch result {
            case .success(let objects):
                self?.dataSource = objects.sorted(by: { $0.date > $1.date })
                sucessCompletion?()
            case .failure(let error):
                self?.errorHandler(error)
            }
        }
    }
    
    private func openMenuAction() {
        let controller = UIAlertController()
        let clearLocalLoggsAction = UIAlertAction(title: "Clear local loggs", style: .destructive) { _ in
            DVDebug.default.clearLocalLogs()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(clearLocalLoggsAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Refreshing
    
    private func setupRefreshController() {
        let controller = UIRefreshControl()
        self.tableViewRefreshController = controller
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = controller
        } else {
            self.tableView.insertSubview(controller, at: 0)
        }
        controller.addTarget(self, action: #selector(self.refreshData(sender:)), for: .valueChanged)
    }
    
    @objc private func refreshData(sender: UIRefreshControl) {
        guard !isRefreshing else {
            return
        }
        updateData() {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Filtering help methods
    
    private func modelFor(indexPath: IndexPath) -> DVLoggerObject {
        guard isFilteringState else {
            return dataSource[indexPath.row]
        }
        return filteredDataSource[indexPath.row]
    }
    
    private func updateFilterArray() {
        guard searchPhrases.count > 0 else {
            self.filteredDataSource = []
            return
        }
        
        let searchPrases = self.searchPhrases
        self.filteredDataSource = self.dataSource .filter {
                for word in searchPrases {
                    if !$0.content.lowercased().contains(word) {
                        return false
                    }
                }
                return true }
    }
}

// MARK: - UITableViewDataSource

extension DebugLoggerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilteringState ? self.filteredDataSource.count : self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoggerCell.self), for: indexPath) as? LoggerCell else {
            return UITableViewCell()
        }
        let model = modelFor(indexPath: indexPath)
        cell.configure(logger: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = modelFor(indexPath: indexPath)
            DVDebug.default.remove(log: model) { [weak self] result in
                switch result {
                case .success():
                    self?.updateData(sucessCompletion: {
                        self?.updateData(sucessCompletion: {
                            DispatchQueue.main.async { [weak self] in
                                self?.tableView.reloadData()
                            }
                        })
                        
                    })
                case .failure(let error):
                    self?.errorHandler(error)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension DebugLoggerViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.tableView else { return }
        self.view.endEditing(true)
    }
}

// MARK: - UISearchBarDelegate

extension DebugLoggerViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if var text = searchBar.text, text.count > 3, text.first == "\"", text.last == "\"" {
            text.removeFirst()
            text.removeLast()
            self.searchPhrases = [text]
        } else {
            let searchPhrases = (searchBar.text ?? "").split{ !$0.isLetter }.map { String($0).lowercased() }
            self.searchPhrases = searchPhrases
        }
        self.updateFilterArray()
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText == "" else {
            return
        }
        self.searchPhrases = []
        self.updateFilterArray()
        self.tableView.reloadData()
    }
}
