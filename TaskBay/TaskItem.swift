//
//  TaskItem.swift
//  TaskBay
//
//  Created by Gabriel Bonomo Dazzi on 23/04/25.
//

import Foundation

struct TaskItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}
