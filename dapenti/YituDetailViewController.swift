//
//  YituDetailViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/21.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class YituDetailViewController: UIViewController {

    var webView:WKWebView!
    
    var urlString:String?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView = WKWebView()
        view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
        }
        
        if urlString != nil {
            
            if let url = URL(string: urlString!) {
                let request = URLRequest(url: url)
                
                webView.load(request)
            }
        }
        
    }
    
    func getImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.webView.bounds.size, true, 0)
        for subView: UIView in self.webView.subviews {
            subView.drawHierarchy(in: subView.bounds, afterScreenUpdates: true)
        }
        //UIApplication.sharedApplication().keyWindow?.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //let imagRef = CGImageCreateWithImageInRect((image?.CGImage)!, context.fromViewController.webView.bounds)
        //let newImage = UIImage.init(CGImage: imagRef!)
        
        return image!
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
