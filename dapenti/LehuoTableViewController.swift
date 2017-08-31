//
//  LehuoTableViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/18.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMobileAds

class LehuoTableViewController: UITableViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var lehuoArray:[LehuoItem] = []
    
    var loadingData = false
    
    var page = 1
    
    let pageCount = 10
    
    var selectItem:LehuoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let headerView = AdHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 116))
        headerView.bannerView.rootViewController = self
        headerView.bannerView.load(GADRequest())
        self.tableView.tableHeaderView = headerView
        
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
        let urlString = serverAddress + "?s=/Home/api/lehuo/p/\(page)/limit/\(pageCount)"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession(configuration:.default, delegate: self, delegateQueue: nil)
        
        
        let sesstionTask = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {

                self.refreshControl?.endRefreshing()
                SVProgressHUD.dismiss()
                self.spinner.stopAnimating()
                self.loadingData = false

            }
                        
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                //print("Response: \(response)")
                //print("DATA:\n\(string)\nEND DATA\n")
                
                
                let json = try?JSONSerialization.jsonObject(with: data, options: [])
                
                if let dict = json as? [String:Any] {
                    
                    if let data = dict["data"] as? [Any] {
                        
                        if self.page == 1 {
                            self.lehuoArray.removeAll()
                        }
                        
                        for dict in data {
                            let item = LehuoItem(json: dict as! [String:Any])
                            
                            self.lehuoArray.append(item)
                            
                        }

                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                            
                        }
                    }
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
        return self.lehuoArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        let item = self.lehuoArray[indexPath.row]
        
        let desStr = (item.title ?? "") as NSString
        let des = desStr.jk_stringByConvertingHTMLToPlainText()
        
        cell.textLabel?.text = des

        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !loadingData && indexPath.row == lehuoArray.count - 1 {
            spinner.startAnimating()
            loadingData = true
            page += 1
            self.requestData()
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectItem = lehuoArray[indexPath.row]
        self.performSegue(withIdentifier: "showLehuoDetail", sender: nil)
        
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLehuoDetail" {
            
            let controller = segue.destination as! LehuoDetailViewController
            
            controller.urlString = self.selectItem?.description
            controller.lehuoInfo = self.selectItem
        }
    }
}

extension LehuoTableViewController:URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            
        }
    }
    
}
