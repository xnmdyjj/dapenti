//
//  TuguaDetailViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/18.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import SVProgressHUD

class TuguaDetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView:WKWebView!
    
    var urlString:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView = WKWebView()
        //webView.scrollView.delegate = self
        webView.navigationDelegate = self
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
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()

    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        SVProgressHUD.dismiss()

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()

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

/*
extension TuguaDetailViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let translation = scrollView.panGestureRecognizer.translation(in: self.webView)
        
        if translation.y < 0 {
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
        }else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)

        }
    }
}*/
