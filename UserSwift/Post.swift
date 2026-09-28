//
//  Post.swift
//  UserSwift
//
//  Created by Виктор on 28.09.2026.
//

import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
