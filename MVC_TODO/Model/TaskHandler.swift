//
//  TaskHandler.swift
//  ToDo
//
//  Created by Joaquim Pessoa Filho on 19/05/19.
//  Copyright © 2019 Joaquim Pessoa Filho. All rights reserved.
//

import Foundation

enum TaskLoadResponse: Error {
    case success(tasks: [Task])
    case error(description: String)
}

enum TaskUpdateResponse: Error {
    case success(tasks: Task)
    case error(description: String)
}

class TaskHandler {
    private static let BASE_URL:String = "https://jsonplaceholder.typicode.com/todos"
    
    // =================
    // Public function
    // =================
    static func create(task: Task, withCompletion completion:(TaskUpdateResponse) -> Void) {
        do {
            try TaskDAO.shared.create(newEntity: task)
            completion(TaskUpdateResponse.success(tasks: task))
        }catch{
            completion(TaskUpdateResponse.error(description: "OPS!! We have a problem to create your Task"))
        }
    }
    
    static func loadTasksWith(completion: @escaping (TaskLoadResponse) -> Void) {
        fetchFromWeb { (response) in
            switch (response) {
            case .error(let description):
                print(description)
            case .success(let tasks):
                saveLocally(tasks)
            }
            
            do {
                 let tasks = try TaskDAO.shared.read()
                completion(TaskLoadResponse.success(tasks: tasks))
            }catch{
                print("Error to load local tasks: \(error)")
                completion(TaskLoadResponse.error(description: "OPS!! We have a problem to load your Tasks"))
            }
        }
    }
    
    static func update(task: Task, withCompletion completion:(TaskUpdateResponse) -> Void) {
        do {
            try TaskDAO.shared.update(entity: task)
            completion(TaskUpdateResponse.success(tasks: task))
        }catch{
            completion(TaskUpdateResponse.error(description: "OPS!! We have a problem to update your Task"))
        }
    }
    
    static func delete(task: Task, withCompletion completion:(TaskUpdateResponse) -> Void) {
        do {
            try TaskDAO.shared.delete(entity: task)
            completion(TaskUpdateResponse.success(tasks: task))
        }catch{
            completion(TaskUpdateResponse.error(description: "OPS!! We have a problem to delete your Task"))
        }
    }
    
    
    // =================
    // Private function
    // =================
    static private func fetchFromWeb(completion: @escaping (TaskLoadResponse) -> Void) {
        guard let url = URL(string: BASE_URL) else {
            completion(TaskLoadResponse.error(description: "URL not initiated"))
            return;
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            guard error == nil, let jsonData = data else {
                completion(TaskLoadResponse.error(description: "Error to unwrapp data variable"))
                return
            }
            
            if let todos = try? JSONDecoder().decode(Todo.self, from: jsonData) {
                completion(TaskLoadResponse.success(tasks: todos))
            } else {
                completion(TaskLoadResponse.error(description: "Error to convert data to [Task]"))
            }
        }).resume()
    }
    
    static private func saveLocally(_ tasks: [Task]) {
        for task in tasks {
            do {
                try TaskDAO.shared.create(newEntity: task)
            }catch{
                print("Error to save task \"\(task.title)\" locally");
            }
        }
    }
}
