//
//  YituItem.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/21.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import Foundation
import SwiftyJSON

struct YituItem {
    
    var title:String?
    var link:String?
    var description:String?
    var imgurl:String?
    
}

extension YituItem {
    
    init(json:JSON) {
        
        self.title = json["title"].string
        
        self.link = json["link"].string
        
        self.description = json["description"].string
        
        self.imgurl = json["imgurl"].string
    }
    
}
