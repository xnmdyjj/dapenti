//
//  AdViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2017/8/31.
//  Copyright © 2017年 yujianjun. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdViewController: UIViewController {

    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
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
