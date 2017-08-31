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
import GoogleMobileAds

class TuguaDetailViewController: UIViewController, WKNavigationDelegate, GADBannerViewDelegate {
    
    var webView:WKWebView!
    
    var urlString:String?
    
    var tuguaInfo:TuguaItem?
    
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
        
        bannerView.delegate = self
        self.view.addSubview(bannerView)
        bannerView.adUnitID = adId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(gesture:)));
//        self.webView.addGestureRecognizer(gesture)
        
    }
    
//    func tapped(gesture:UITapGestureRecognizer) {
//        let touchPoint = gesture.location(in: self.webView)
//        let js = "document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).src"
//        self.webView.evaluateJavaScript(js) { (response, error) in
//            print(error ?? "get url no error")
//        }
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }

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
