//
//  YituTableViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/21.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class YituTableViewController: UITableViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var yituArray:[YituItem] = []
    
    var loadingData = false
    
    var page = 1
    
    let pageCount = 20
    
    var selectIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        refreshControl = UIRefreshControl()
        
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        
        self.requestData()
    
    }
    
    
    func refresh() {
        
        page = 1
        
        self.requestData()
    }
    
    
    func requestData()  {
        let urlString = serverAddress + "?s=/Home/api/yitu/p/\(page)/limit/\(pageCount)"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession(configuration:.default, delegate: self, delegateQueue: nil)
        
        
        let sesstionTask = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
            
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                //print("Response: \(response)")
                //print("DATA:\n\(string)\nEND DATA\n")
                
                let json = JSON(data: data)
                let data = json["data"].arrayValue
                
                for json in data {
                    
                    let item = YituItem(json: json)
                    
                    self.yituArray.append(item)
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
        return self.yituArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YituTableViewCell

        // Configure the cell...
        
        let item = yituArray[indexPath.row]
        
        if let imgurl = item.imgurl {
            
            if let url = URL(string: imgurl) {
                
                let resource = ImageResource(downloadURL: url)
                
                cell.iconView?.kf.setImage(with: resource)
                
            }
        }
        
        cell.titleLabel?.text = item.title
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if !loadingData && indexPath.row == yituArray.count - 1 {
            spinner.startAnimating()
            loadingData = true
            page += 1
            self.requestData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectIndex = indexPath.row
        
        self.performSegue(withIdentifier: "showContainerView", sender: nil)
    
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showContainerView" {
            
            let controller = segue.destination as! YituContainerViewController
            
            controller.currentIndex = selectIndex
            controller.yituArray = yituArray
        }
    }
    


}

extension YituTableViewController:URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            
        }
    }
}
