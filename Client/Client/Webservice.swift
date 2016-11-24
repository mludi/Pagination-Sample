//
//  Webservice.swift
//  Client
//
//  Created by Matthias Ludwig on 23.11.16.
//  Copyright © 2016 Matthias Ludwig. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case noData
    case couldNotConvert
}

public typealias JSON = [String: AnyObject]
public typealias JSONArray = [JSON]

final class Webservice {
    typealias PostCompletionHandler = ([Post], _ totalPages: Int, _ totalPosts: Int, _ error: NetworkError?) -> ()
    typealias CreatePostCompletionHandler = () -> ()
    
    // MARK: - Networking
    
    static func posts(currentPage inCurrentPage: Int, withDelay inDelay: UInt32, completionHandler: @escaping PostCompletionHandler) {
        if inCurrentPage == 0 { return }
        var returnList = [Post]()
        guard let theURL = APIEndpoint.posts(inCurrentPage).url() else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: theURL), completionHandler: { data, response, error in
            sleep(inDelay)
            if let _ = error {
                completionHandler(returnList, 0, 0, .networkError)
                return
            }
            if let theResponse = response as? HTTPURLResponse {
                if theResponse.statusCode == 200 {
                    guard let theData = data else {
                        completionHandler(returnList, 0, 0, .noData)
                        return
                    }
                    guard let theJSON = try? JSONSerialization.jsonObject(with: theData, options: []) as? JSONArray,
                    let innerDict = theJSON?[0],
                    let posts = innerDict["posts"] as? JSONArray,
                    let totalPages = innerDict["total_pages"] as? Int,
                    let totalPosts = innerDict["total"] as? Int
                        else {
                            completionHandler(returnList, 0, 0, .couldNotConvert)
                            return
                    }
                    for post in posts {
                        guard let aPost = Post(dictionary: post) else { continue }
                        returnList.append(aPost)
                    }
                    completionHandler(returnList, totalPages, totalPosts, nil)

                }
            }
        }).resume()
    }
    
    func createDemoData(completionHandler: @escaping CreatePostCompletionHandler) {
        let group = DispatchGroup()
        guard let URL = APIEndpoint.createPosts.url() else { fatalError() }
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        for _ in 0..<50 {
            let bodyObject: [String : Any] = [
                "content": randomString(length: 20)
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyObject, options: [])
            group.enter()
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error  in
                if let error = error {
                    print("URL Session Task Failed: %@", error.localizedDescription)
                }
                else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode
                    if statusCode == 200 {
                        print("URL Session Task Succeeded: HTTP \(statusCode)")
                    }
                    else {
                        print("an error ...")
                    }
                }
                group.leave()
            }).resume()
        }
        group.notify(queue: DispatchQueue.main) {
            completionHandler()
        }
    }
    
    // MARK: - Helper
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}
