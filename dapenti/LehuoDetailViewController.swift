//
//  LehuoDetailViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/20.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import GoogleMobileAds

class LehuoDetailViewController: UIViewController, WKNavigationDelegate {

    var webView:WKWebView!
    
    var urlString:String?
    
    var lehuoInfo: LehuoItem?
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem = shareBarButtonItem
        
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

        bannerView = GADBannerView(adSize: kGADAdSizeBanner, origin: CGPoint(x: (kScreenWidth - kGADAdSizeBanner.size.width)/2, y: kScreenHeight - kGADAdSizeBanner.size.height))
        
        self.view.addSubview(bannerView)
        bannerView.adUnitID = adId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func shareAction() {
        guard let item = lehuoInfo else {
            return
        }
        
        var activityItems:[Any] = []
        if let shareTitle = item.title  {
            activityItems.append(shareTitle)
        }
        
        if let shareLink = item.description {
            if let shareUrl = URL(string:shareLink) {
                activityItems.append(shareUrl)
            }
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .copyToPasteboard, .assignToContact, .print, .mail, .postToTencentWeibo, .saveToCameraRoll, .message]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
        let js = "var y = document.getElementsByClassName('adsbygoogle');for (var i = 0; i < y.length; i++) {y[i].style.display = 'none';}"
        webView.evaluateJavaScript(js) { (response, error) in
            print(error ?? "no error")
        }
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        SVProgressHUD.dismiss()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
        
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


/*
extension LehuoDetailViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let translation = scrollView.panGestureRecognizer.translation(in: self.webView)
        
        if translation.y < 0 {
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
        }else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
    }
}*/
