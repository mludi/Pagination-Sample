//
//  ViewController.swift
//  Client
//
//  Created by Matthias Ludwig on 21.11.16.
//  Copyright © 2016 Matthias Ludwig. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController {
    
    // MARK: - Properties
    
    var posts = [Post]()
    var currentPage = 0
    var totalPages = 0
    var totalPosts = 0
    let cellTag = 1337


    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alertController = UIAlertController(title: "Info", message: "Shake your phone to create more Demo Data", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Loading
    
    fileprivate func loadPosts() {
        Webservice.posts(currentPage: currentPage, withDelay: 1) { [weak self] (inPosts, inTotalPages, inTotalPosts, inError) in
            if let error = inError {
                // TODO: Handle
                switch error {
                case .noData:
                    print("no data ... ")
                    break
                case .networkError:
                    print("network error ... ")
                    break
                case .couldNotConvert:
                    print("could not convert ... ")
                    break
                }
            }

            for post in inPosts {
                guard let thePosts = self?.posts else { fatalError() }
                if !thePosts.contains(where: { $0 == post }) {
                    self?.posts.append(post)
                }
            }
            self?.totalPages = inTotalPages
            self?.totalPosts = inTotalPosts
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentPage == 0 {
            return 1
        }
        if currentPage < totalPages {
            return posts.count + 1
        }
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < posts.count {
            return postCell(for: indexPath)
        }
        return loadingCell(for: indexPath)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.tag == cellTag {
            currentPage = currentPage + 1
            loadPosts()
        }
    }
    
    // MARK: - Helper
    
    fileprivate func postCell(for inIndexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: inIndexPath)
        let post = posts[inIndexPath.row]
        cell.textLabel?.text = "(\(post.id)) \(post.content)"
        return cell
    }
    
    fileprivate func loadingCell(for inIndexPath: IndexPath) -> LoadingCell {
        guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: inIndexPath) as? LoadingCell else {
            return LoadingCell()
        }
        loadingCell.tag = cellTag
        loadingCell.indicator?.startAnimating()
        return loadingCell
    }
    
    // MARK: - Motion
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            Webservice().createDemoData { [weak self] in
                self?.currentPage = 0
                self?.totalPages = 0
                self?.posts = []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    let alertController = UIAlertController(title: "Info", message: "Created more Demo Data", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
