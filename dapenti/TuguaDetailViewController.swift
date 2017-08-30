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
import Kingfisher

class TuguaDetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView:WKWebView!
    
    var urlString:String?
    
    var tuguaInfo:TuguaItem?
    

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
    
    }

    func shareAction() {
        guard let item = tuguaInfo else {
            return
        }
        
        var activityItems:[Any] = []
        if let shareTitle = item.title  {
            activityItems.append(shareTitle)
        }
        
        if let imageUrl = item.imgurl {
            if let shareImage = self.getCachedImage(imageUrlString: imageUrl) {
                activityItems.append(shareImage)
            }
        }
        
        if let shareLink = item.desc {
            if let shareUrl = URL(string:shareLink) {
                activityItems.append(shareUrl)
            }
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .copyToPasteboard, .assignToContact, .print, .mail, .postToTencentWeibo, .saveToCameraRoll, .message]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    func getCachedImage(imageUrlString:String) -> UIImage? {
        
        let isCached = ImageCache.default.isImageCached(forKey: imageUrlString)
        
        if isCached.cached {
            
            let imageFromMemory = ImageCache.default.retrieveImageInMemoryCache(forKey: imageUrlString)
            
            if imageFromMemory != nil {
                
                return imageFromMemory
                
            }else {
                let imageFromDisk = ImageCache.default.retrieveImageInDiskCache(forKey: imageUrlString)
                
                if imageFromDisk != nil {
                    
                    return imageFromDisk
                }
            }
        }
        return nil
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
