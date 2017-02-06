//
//  CreateDemoDataViewController.swift
//  Client
//
//  Created by Matthias Ludwig on 24.11.16.
//  Copyright © 2016 Matthias Ludwig. All rights reserved.
//

import UIKit

protocol CreateDemoDataViewControllerDelegate: class {
    func createDemoDataViewControllerDidFinish()
}

class CreateDemoDataViewController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: CreateDemoDataViewControllerDelegate?
    
    // MARK: - ButtonActions
    
    @IBAction func createDemoDataTouchUpInside(_ sender: Any) {
        Webservice().createDemoData { [weak self] in
            self?.delegate?.createDemoDataViewControllerDidFinish()
        }
    }    
}
