//
//  DuanziTableViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/26.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class DuanziTableViewController: UITableViewController {

    var duanziArray:[DuanziItem] = []
    
    var loadingData = false
    
    var page = 1
    
    let pageCount = 20
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        SVProgressHUD.show()
        self.requestData()
        
    }
    
    func refresh() {
        
        page = 1
        self.requestData()
    }
    
    
    func requestData()  {
        let urlString = serverAddress + "?s=/Home/api/duanzi/p/\(page)/limit/\(pageCount)"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession(configuration:.default, delegate: self, delegateQueue: nil)
        
        
        let sesstionTask = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                SVProgressHUD.dismiss()
            }
            
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                //print("Response: \(response)")
                //print("DATA:\n\(string)\nEND DATA\n")
                
                let json = JSON(data: data)
                let data = json["data"].arrayValue
                
                if self.page == 1 {
                    self.duanziArray.removeAll()
                }
                
                for json in data {
                    
                    let item = DuanziItem(json: json)
                    
                    self.duanziArray.append(item)
                }
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    self.loadingData = false
                    
                }
                
            }
        }
        
        sesstionTask.resume()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.duanziArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "duanziCell", for: indexPath) as! DuanziTableViewCell

        // Configure the cell...
        
        let item = self.duanziArray[indexPath.row]
        
        let aux = "<span style=\"font-family: Helvetica; font-size: 17\">\(item.description!)</span>"

        let data = aux.data(using: .unicode)
        
        let attrStr = try? NSAttributedString(data: data!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        
        cell.desLabel.attributedText = attrStr
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if !loadingData && indexPath.row == duanziArray.count - 1 {
            spinner.startAnimating()
            loadingData = true
            page += 1
            self.requestData()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension DuanziTableViewController:URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            
        }
    }
}
