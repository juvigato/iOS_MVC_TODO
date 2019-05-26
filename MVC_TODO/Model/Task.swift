//
//  ToDo.swift
//  ToDo
//
//  Created by Joaquim Pessoa Filho on 18/05/19.
//  Copyright © 2019 Joaquim Pessoa Filho. All rights reserved.
//

import Foundation

// MARK: - ToDo
struct Task: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}

typealias Todo = [Task]

