//
//  APIEndpoint.swift
//  Client
//
//  Created by Matthias Ludwig on 23.11.16.
//  Copyright © 2016 Matthias Ludwig. All rights reserved.
//

import Foundation

private let baseURLString = "http://localhost:8080/api/v1"

enum APIEndpoint {
    
    case posts(Int)
    case createPosts
    
    func url() -> URL? {
        switch self {
        case .posts(let currentPage):
            return URL(string: "\(baseURLString)/posts?page=\(currentPage)")
        case .createPosts:
            return URL(string: "\(baseURLString)/posts")
        }
        
        
    }
}
