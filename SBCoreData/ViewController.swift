//
//  ViewController.swift
//  SBCoreData
//
//  Created by Soham Bhattacharjee on 21/07/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "UserCell", bundle: .main), forCellReuseIdentifier: "UserCell")
        }
    }
    
    // MARK: Variables
    private var viewModel: UserViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(update))
        
        self.setup()

        self.viewModel?.loadDataSource()
    }
    
    // MARK: - Setup ViewModel
    private func setup() {
        self.viewModel = UserViewModel()
        
        self.viewModel?.onDataSourceLoaded = { [weak self] in
            if let count = self?.viewModel?.getResultCount(), count > 0 {
                self?.title = "Total Users: \(count)"
            }
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Update
    @objc
    private func update() {
        self.viewModel?.updateDataSource()
    }

    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsForSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        if let cvm = self.viewModel?.cellViewModel(at: indexPath) {
            cell.bind(vm: cvm)
        }
        
        return cell
    }
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = self.viewModel?.getURL(for: indexPath) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { (loaded) in
                    DPrint(loaded)
                }
            }
        }
    }
}

