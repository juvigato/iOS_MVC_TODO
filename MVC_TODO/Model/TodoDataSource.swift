//
//  TodoDataSource.swift
//  ToDo
//
//  Created by Joaquim Pessoa Filho on 19/05/19.
//  Copyright © 2019 Joaquim Pessoa Filho. All rights reserved.
//

import UIKit

protocol TaskDelegate: class {
    func change(task:Task)
}

class TodoDataSource: NSObject, UITableViewDataSource, TaskDelegate {
    
    var tasks: [Task]
    
    init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    //data source podia ficar na controller por causa dessa proxima func, sa vezes elas se "misturam"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskTableViewCell else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Error"
            return cell
        }
        
        cell.task = self.tasks[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    //TaskDelegate Methdos
    func change(task: Task) {
        TaskHandler.update(task: task) { (response) in
            switch (response) {
            case .success( _):
                print("Task Atualizada")
            case .error(let description):
                print(description)
            }
        }
    }
}
