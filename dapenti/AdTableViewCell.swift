//
//  AdTableViewCell.swift
//  dapenti
//
//  Created by 喻建军 on 2017/8/30.
//  Copyright © 2017年 yujianjun. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdTableViewCell: UITableViewCell {

    var bannerView: GADBannerView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner, origin: CGPoint(x:(kScreenWidth - kGADAdSizeLargeBanner.size.width)/2 , y: 8))
        
        self.contentView.addSubview(bannerView)
        //bannerView.adUnitID = "ca-app-pub-8461828727506882/2269890330"
        bannerView.adUnitID = adId
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
    }
    
    
    required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
