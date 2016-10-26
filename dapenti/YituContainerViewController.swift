//
//  YituContainerViewController.swift
//  dapenti
//
//  Created by 喻建军 on 2016/10/21.
//  Copyright © 2016年 yujianjun. All rights reserved.
//

import UIKit

class YituContainerViewController: UIViewController {
    
    var pageViewController:UIPageViewController!
    
    var yituArray:[YituItem] = []
    
    var currentIndex:Int = 0
    
    var viewControllers:[YituDetailViewController?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
}
