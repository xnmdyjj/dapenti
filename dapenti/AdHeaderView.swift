//
//  AdHeaderView.swift
//  dapenti
//
//  Created by 喻建军 on 2017/8/31.
//  Copyright © 2017年 yujianjun. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var bannerView: GADBannerView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner, origin: CGPoint(x:(kScreenWidth - kGADAdSizeLargeBanner.size.width)/2 , y: 8))
        
        self.addSubview(bannerView)
        bannerView.adUnitID = adId
        
    }

    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
