//
//  TaskDAO.swift
//  ToDo
//
//  Created by Joaquim Pessoa Filho on 19/05/19.
//  Copyright © 2019 Joaquim Pessoa Filho. All rights reserved.
//

import Foundation
import CoreData


struct TaskDAO: GenericDAO {
    typealias T = Task
    let managedContext = CoreDataManager.shared.persistentContainer.viewContext
    private let entityName = "TaskEntity"
    
    //Singleton
    static let shared:TaskDAO = TaskDAO()
    private init(){}
    // ----
    
    func create(newEntity: Task) throws {
        if idExists(id: newEntity.id) {
            throw DAOError.invalidData(description: "ID already exists")
        }
        
        guard let taskEntity = NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext) else {
            throw DAOError.internalError(description: "Failed to create NSEntityDescription Entity")
        }
        
        guard let task = NSManagedObject(entity: taskEntity, insertInto: managedContext) as? TaskEntity else {
            throw DAOError.internalError(description: "Failed to create NSManagedObject")
        }
        
        task.id         = Int64(newEntity.id)
        task.userID     = Int64(newEntity.userID)
        task.title      = newEntity.title
        task.completed  = newEntity.completed
        
        do {
            try managedContext.save()
        } catch {
            throw DAOError.internalError(description: "Problem to save Task using CoreData")
        }
    }
    
    func read() throws -> Todo {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            guard let tasksData = result as? [TaskEntity] else {
                throw DAOError.internalError(description: "Error to cast fetch result to [TaskEntity]")
            }
            
            var tasks:[Task] = []
            
            for data in tasksData {
                tasks.append(Task(userID: Int(data.userID),
                                  id: Int(data.id),
                                  title: data.title ?? "",
                                  completed: data.completed))
            }
            
            return tasks
        } catch {
            throw DAOError.internalError(description: "Problema during CoreData fetch")
        }
    }
    
    func update(entity: Task) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    
    func delete(entity: Task) throws {
        throw DAOError.internalError(description: "Not implement")
    }
    
    private func idExists(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            return result.count > 0
        } catch {
            print("Problema during CoreData fetch")
            return false;
        }
    }
}
