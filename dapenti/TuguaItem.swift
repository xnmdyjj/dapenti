//
//  TuguaItem.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/14.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import Foundation

class TuguaItem: NSObject, NSCoding {
    
    var title:String?
    var link:String?
    var desc:String?
    var imgurl:String?
    
    init(json:[String:Any]) {
        
        self.title = json["title"] as! String?
        
        self.link = json["link"] as! String?
        
        self.desc = json["description"] as! String?
        
        self.imgurl = json["imgurl"] as! String?
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String?
        
        link = aDecoder.decodeObject(forKey: "link") as! String?
        
        desc = aDecoder.decodeObject(forKey: "description") as! String?
        
        imgurl = aDecoder.decodeObject(forKey: "imgurl") as! String?
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(desc, forKey: "description")
        aCoder.encode(imgurl, forKey: "imgurl")
    }

}
