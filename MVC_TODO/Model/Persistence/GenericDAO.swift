//
//  GenericDAO.swift
//  ToDo
//
//  Created by Joaquim Pessoa Filho on 19/05/19.
//  Copyright © 2019 Joaquim Pessoa Filho. All rights reserved.
//

import Foundation

enum DAOError: Error {
    case invalidData(description: String)
    case internalError(description: String)
}

protocol GenericDAO {
    associatedtype T
    
    func create(newEntity: T) throws
    func read() throws -> [T]
    func update(entity: T) throws
    func delete(entity: T) throws
}
