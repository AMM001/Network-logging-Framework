//
//  ViewController.swift
//  InstabugInterview
//
//  Created by Yousef Hamza on 1/13/21.
//

import UIKit
import InstabugNetworkClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getApi()
        // Do any additional setup after loading the view.
    }
    
    // https://httpbin.org
    func getApi() {
        if let url = URL(string: "https://httpbin.org/anything") {
            NetworkClient.shared.get(url) { data in
                print(data)
                
            }
        }
    }
}

