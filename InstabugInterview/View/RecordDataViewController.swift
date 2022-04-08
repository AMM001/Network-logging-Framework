//
//  ViewController.swift
//  InstabugInterview
//
//  Created by Yousef Hamza on 1/13/21.
//

import UIKit
import InstabugNetworkClient

class ViewController: UIViewController {
    
    //MARK:-Outlets
    @IBOutlet weak var postRequestBtn: LoadingButton!
    @IBOutlet weak var getRequestBtn: LoadingButton!
    @IBOutlet weak var putRequestBtn: LoadingButton!
    @IBOutlet weak var deleteRequestBtn: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Mark:-Actions
    @IBAction func postRequestBtn(_ sender: Any) {
        self.postRequestBtn.showLoading()
        NetworkClient.instance.request(with: APIRouter.postRequest) { result in
            self.postRequestBtn.hideLoading()
            switch result {
            case .result(_, let response):
                print(response!.statusCode)
                self.postRequestBtn.setTitle("Post Request Stored ....", for: .normal)
            case .error(let error, _):
                self.postRequestBtn.setTitle("Post Request Failed to Stored ....", for: .normal)
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func getRequestBtn(_ sender: Any) {
        self.getRequestBtn.showLoading()
        NetworkClient.instance.request(with: APIRouter.getRequest) { result in
            self.getRequestBtn.hideLoading()
            switch result {
            case .result(_, let response):
                print(response!.statusCode)
                self.getRequestBtn.setTitle("get Request Stored ....", for: .normal)
            case .error(let error, _):
                print(error!.localizedDescription)
                self.getRequestBtn.setTitle("get Request Failed to Stored ....", for: .normal)
            }
        }
    }
    
    @IBAction func putRequestBtn(_ sender: Any) {
        self.putRequestBtn.showLoading()
        NetworkClient.instance.request(with: APIRouter.PutRequest) { result in
            self.putRequestBtn.hideLoading()
            switch result {
            case .result(_, let response):
                self.putRequestBtn.setTitle("put Request Stored ....", for: .normal)
                print(response!.statusCode)
            case .error(let error, _):
                print(error!.localizedDescription)
                self.putRequestBtn.setTitle("put Request Failed to Stored ....", for: .normal)
            }
        }
    }
    
    @IBAction func deleteRequestBtn(_ sender: Any) {
        let context = PersistentContainer.shared.viewContext
        RequestOperationsHandler.shared.getDataRecords(context: context)
//        self.deleteRequestBtn.showLoading()
//        NetworkClient.instance.request(with: APIRouter.deleteRequest) { result in
//            self.deleteRequestBtn.hideLoading()
//            switch result {
//            case .result(_, let response):
//                print(response!.statusCode)
//                self.deleteRequestBtn.setTitle("delete Request Stored ....", for: .normal)
//            case .error(let error, _):
//                print(error!.localizedDescription)
//                self.deleteRequestBtn.setTitle("delete Request Failed to Stored ....", for: .normal)
//            }
//        }
    }
    
    @IBAction func loadDataBtn(_ sender: Any) {
        
    }
    
}

