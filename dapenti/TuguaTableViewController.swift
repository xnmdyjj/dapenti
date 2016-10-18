//
//  TuguaTableViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/12.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import Kingfisher

class TuguaTableViewController: UITableViewController {
    
    var tuguaArray:[TuguaItem] = []
    
    var imageheightAtUrl:[String:CGFloat] = [:]
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        requestData()
    }
    
    func requestData() {
        
        let urlString = serverAddress + "?s=/home/api/tugua/p/1/limit/30"
    
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        

        
        let sessionTask = session.dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                
                guard let data = data else {
                    return
                }
                
                let json = try?JSONSerialization.jsonObject(with: data, options: [])
                
                if let dict = json as? [String:Any] {

                    if let data = dict["data"] as? [Any] {
                        
                        for dict in data {
                            let item = TuguaItem(json: dict as! [String:Any])
                            
                            self.tuguaArray.append(item)
                            
                        }
                        
                        for item in self.tuguaArray {
                            
                            if let imageUrl = item.imgurl {
                                self.handleImageHeight(imageUrlString: imageUrl);
                            }
                        }
                        
                        self.tableView.reloadData()
                    }
                }

            }
        }
        
        sessionTask.resume()
    }
    
    
    func handleImageHeight(imageUrlString:String) {
        
        let isCached = ImageCache.default.isImageCached(forKey: imageUrlString)
        
        if isCached.cached {
            
            let imageFromMemory = ImageCache.default.retrieveImageInMemoryCache(forKey: imageUrlString)
            
            if imageFromMemory != nil {
                
                //set image height
                
                imageheightAtUrl[imageUrlString] = self.calculateImageHeight(image: imageFromMemory!)
                
                
            }else {
                let imageFromDisk = ImageCache.default.retrieveImageInDiskCache(forKey: imageUrlString)
                
                if imageFromDisk != nil {
                    
                    //set Image height
                    
                    imageheightAtUrl[imageUrlString] = self.calculateImageHeight(image: imageFromDisk!)
                    
                }
            }
 
        }else {
            
            let imageUrl = URL(string:imageUrlString)
            
            
            ImageDownloader.default.downloadImage(with: imageUrl!, options: nil, progressBlock: nil) {
                (image, error, url, data) in
                
                if image != nil , url != nil {
                    
                    let urlString = url?.absoluteString
                    
                    self.imageheightAtUrl[urlString!] = self.calculateImageHeight(image:image!)
                    
                    ImageCache.default.store(image!, forKey: urlString!)
                }
    
            }
        }
    }
    
    
    func handleTitleHeight(title:String) -> CGFloat{

        let screenWidth = UIScreen.main.bounds.size.width

        let constraintRect = CGSize(width: screenWidth - 16, height: .greatestFiniteMagnitude)
        
        let font = UIFont.systemFont(ofSize: 17)
        
        let boundingBox = (title as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil);
        
        return boundingBox.height
    }
    
    
    func calculateImageHeight(image:UIImage) -> CGFloat {
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        return (screenWidth - 16) * image.size.height / image.size.width
    
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
        return self.tuguaArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tuguaCell", for: indexPath) as! TuguaTableViewCell

        // Configure the cell...

        let item = tuguaArray[indexPath.row]
    
        cell.titleLabel.text = item.title
        
        let url = URL(string: item.imgurl!)
        
        let resource = ImageResource(downloadURL: url!)
        cell.coverImageView.kf.setImage(with: resource)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = tuguaArray[indexPath.row]
        
        guard let imageUrl = item.imgurl else {
            
            return 44
        }
        
     
        let imageHeight = imageheightAtUrl[imageUrl]
        
        if imageHeight != nil {
            
            if let title = item.title {
                let titleHeight = self.handleTitleHeight(title: title)
                
                return titleHeight + imageHeight! + 24
            }
            
        }
        
        return 300;
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

extension TuguaTableViewController:URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            
        }
    }
}
