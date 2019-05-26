//
//  File.swift
//  ToDo
//
//  Created by Joaquim Pessoa Filho on 19/05/19.
//  Copyright © 2019 Joaquim Pessoa Filho. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    weak var delegate:TaskDelegate?
    
    var task:Task? {
        didSet {
            self.titleLable.text = task?.title ?? "Title Undefined"
            self.userLabel.text = "usuário com id \(task?.userID ?? -1)"
            if task?.completed ?? false {
                self.completedButton.isSelected = true
            } else {
                self.completedButton.isSelected = false
            }
        }
    }
    
    @IBAction func changeStatus(_ sender: Any) {
        if let t = self.task {
            self.task = Task(userID: t.userID, id: t.id, title: t.title, completed: !t.completed)
            delegate?.change(task: self.task!)
        }
        
    }
}
