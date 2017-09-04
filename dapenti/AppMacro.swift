//
//  AppMacro.swift
//  phyh
//
//  Created by 喻建军 on 2017/4/6.
//  Copyright © 2017年 remarkmedia. All rights reserved.
//
import UIKit

//delegate 代理

let MyAppDelegate = UIApplication.shared.delegate as! AppDelegate

// 沙盒文档路径
let kSandDocumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!

let kScreenWidth: CGFloat = UIScreen.main.bounds.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.height

let adId = "ca-app-pub-8461828727506882/2269890330"
//let adId = "ca-app-pub-3940256099942544/6300978111"
