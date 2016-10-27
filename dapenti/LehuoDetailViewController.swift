//
//  LehuoDetailViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/20.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import WebKit

class LehuoDetailViewController: UIViewController {

    var webView:WKWebView!
    
    var urlString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         
        webView = WKWebView()
        webView.scrollView.delegate = self
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



extension LehuoDetailViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let translation = scrollView.panGestureRecognizer.translation(in: self.webView)
        
        if translation.y < 0 {
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
        }else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
    }
}
