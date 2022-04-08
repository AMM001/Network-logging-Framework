//
//  LoadDataViewController.swift
//  InstabugInterview
//
//  Created by admin on 08/04/2022.
//

import UIKit
import InstabugNetworkClient


class LoadDataViewController: UIViewController {
    
    //MARK:-Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var dataLoaded = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.setTitle()
    }
    func setTitle(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Data Loaded count \(dataLoaded.count)"
    }
    
    func loadData() {
        let context = PersistentContainer.shared.viewContext
        dataLoaded =   RequestOperationsHandler.shared.getDataRecords(context: context)
        self.tableView.reloadData()
    }
}

extension LoadDataViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLoaded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataLoaded[indexPath.row]
        return cell
    }
}
