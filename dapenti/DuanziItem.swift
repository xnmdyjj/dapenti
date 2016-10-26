//
//  DuanziItem.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/26.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DuanziItem {
    
    var title:String?
    var link:String?
    var description:String?
    
}

extension DuanziItem {
    
    init(json:JSON) {
        
        self.title = json["title"].string
        
        self.link = json["link"].string
        
        self.description = json["description"].string
        
    }
    
}
