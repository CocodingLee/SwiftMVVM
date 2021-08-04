//
//  ViewController.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/26.
//

import UIKit

class ViewController: FPBaseViewController , UITableViewDelegate , UITableViewDataSource {
    
    private let cellReuseIdentifier = "demo.cell"
    private lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        self.navigationTitle = "首页"
        self.accessibilityId = "xxx.xxx.xxx"
        
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView()
    {
        let y = self.navigationBarHeight
        let frame = CGRect(x: 0, y: y, width: self.view.bounds.width, height: self.view.bounds.height - y)
        tableView.frame = frame
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor(rgb: 0xE7EAF2)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.view.addSubview(tableView)
    }
    
    override func bindViewModel() -> Void {
        
    }
    
    override func setupSubViews() -> Void {
        
    }
    
    override func fetchDataFromServer() -> Void {
        
    }
}

extension ViewController
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

