//
//  YituContainerViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/21.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit
import Kingfisher

class YituContainerViewController: UIViewController {
    
    var pageViewController:UIPageViewController!
    
    var yituArray:[YituItem] = []
    
    var currentIndex:Int = 0
    
    var viewControllers:[YituDetailViewController?] = []
    
    var tempIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.updateTitle()
        
        let shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem = shareBarButtonItem
        
        
        let controller = YituDetailViewController()
        
        let item = yituArray[currentIndex]
        controller.urlString = item.description
        
        viewControllers = Array(repeating: nil, count: yituArray.count)
        viewControllers[currentIndex] = controller
        

        pageViewController = self.childViewControllers.first as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
    }
    
    func updateTitle() {
        self.navigationItem.title = String(self.currentIndex + 1) + "/" + String(yituArray.count)
    }
    
    func shareAction() {
        let item = yituArray[currentIndex]
        
        var activityItems:[Any] = []
        if let shareTitle = item.title  {
            activityItems.append(shareTitle)
        }
        
        if let imageUrl = item.imgurl {
            if let shareImage = self.getCachedImage(imageUrlString: imageUrl) {
                activityItems.append(shareImage)
            }
        }
        
        if let shareLink = item.description {
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
    

    func viewControllerAtIndex(index:Int) -> YituDetailViewController {
        
        let controller = viewControllers[index]
        
        if controller == nil  {
            
            let controller = YituDetailViewController()
            
            let item = yituArray[index]
            controller.urlString = item.description
            
            viewControllers[index] = controller
            
            return controller
        }
    
        return controller!
    }
    
    func indexOfViewController(viewController:YituDetailViewController) -> Int? {
        
        return viewControllers.index(where: {$0 === viewController})
        
    }
}

extension YituContainerViewController:UIPageViewControllerDataSource , UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = self.indexOfViewController(viewController: viewController as! YituDetailViewController)
        
        if var index = index, index != 0{
            
            index = index - 1
            
            return self.viewControllerAtIndex(index: index)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = self.indexOfViewController(viewController: viewController as! YituDetailViewController)
        
        if var index = index, index < self.yituArray.count - 1{
            
            index = index + 1
            
            return self.viewControllerAtIndex(index: index)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed && finished {
            self.currentIndex = self.tempIndex
            self.updateTitle()
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let viewController = pendingViewControllers.first as? YituDetailViewController {
            
            if let index = self.indexOfViewController(viewController: viewController) {
                self.tempIndex = index
            }
        }
    }
}
