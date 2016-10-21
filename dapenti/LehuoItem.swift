//
//  LehuoItem.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/19.
//  Copyright © 2016年 yujianjun. All rights reserved.
//


import Foundation

struct LehuoItem {
    
    var title:String?
    var link:String?
    var description:String?
    var imgurl:String?
    
}

extension LehuoItem {
    
    init(json:[String:Any]) {
        
        self.title = json["title"] as! String?
        
        self.link = json["link"] as! String?
        
        self.description = json["description"] as! String?
        
        self.imgurl = json["imgurl"] as! String?
    }
    
}
