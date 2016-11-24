//
//  Post.swift
//  Client
//
//  Created by Matthias Ludwig on 23.11.16.
//  Copyright © 2016 Matthias Ludwig. All rights reserved.
//

import Foundation

// MARK: - Model

struct Post {
    let id: Int
    let content: String
}

// MARK: - Extension

extension Post {
    init?(dictionary: JSON) {
        guard let id = dictionary["id"] as? Int,
            let content = dictionary["content"] as? String else {
            return nil
        }
        self.id = id
        self.content = content
    }
}

extension Post: Equatable {}
func ==(lhs: Post, rhs: Post) -> Bool {
    return lhs.id == rhs.id
}
