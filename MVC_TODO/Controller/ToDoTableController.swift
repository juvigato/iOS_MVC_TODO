//
//  ViewController.swift
//  ToDo
//
//  Created by Joaquim Pessoa Filho on 18/05/19.
//  Copyright © 2019 Joaquim Pessoa Filho. All rights reserved.
//

import UIKit


class ToDoTableViewController: UITableViewController {
    
    let dataSource: TodoDataSource = TodoDataSource(tasks: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        
        TaskHandler.loadTasksWith { (response) in
            switch(response) {
            case .success(let tasks):
                self.dataSource.tasks = tasks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .error(let description):
                print(description)
            }
        }
    }

    
    
    //UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

