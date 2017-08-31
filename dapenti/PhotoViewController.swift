//
//  PhotoViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2017/8/31.
//  Copyright © 2017年 yujianjun. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class PhotoViewController: UIViewController {
    
    let phoneView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(phoneView)
        phoneView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.requestData()
        
        self.perform(#selector(self.showHomeView), with: self, afterDelay: 2.0)
    }
    
    
    func showHomeView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        MyAppDelegate.window?.rootViewController = controller
        
    }
    
    
    func requestData()  {
        let urlString = serverAddress + "?s=/home/api/loading_pic"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession(configuration:.default, delegate: self, delegateQueue: nil)
        
        
        let sesstionTask = session.dataTask(with: request) { (data, response, error) in
            
           
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                //print("Response: \(response)")
                //print("DATA:\n\(string)\nEND DATA\n")
                
                let json = JSON(data: data)
                let data = json["data"].stringValue
                
                
                DispatchQueue.main.async {
                    
                    if let url = URL(string: data) {
                        let resource = ImageResource(downloadURL: url)
                        self.phoneView.kf.setImage(with: resource)
                        
                        
                    }
                    
                }
                
            }
        }
        
        sesstionTask.resume()
        
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension PhotoViewController:URLSessionDelegate, URLSessionDataDelegate{
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            
        }
    }
}
