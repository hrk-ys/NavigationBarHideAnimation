//
//  ViewController.swift
//  NavigationBarHideAnimation
//
//  Created by Hiroki Yoshifuji on 2015/03/19.
//  Copyright (c) 2015年 Hiroki Yoshifuji. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    private var headerViewHeight:CGFloat = 35
    private var scrollInsentOffset:CGFloat = 35
    private var naviScrollOldConstant:CGFloat = 0
    private var naviScrollOldVal:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = "\(indexPath.section) - \(indexPath.row)"
        
        return cell
    }
    
    // 上に隠れる時は self.topConstraintはマイナスになる
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if scrollView.contentSize.height < offsetY { return }
        if offsetY < 0 && self.topConstraint.constant < 0 {
            self.topConstraint.constant = 0
            return
        }
        if offsetY >= 0 {
            var constant = naviScrollOldConstant - (offsetY - naviScrollOldVal)
            
            if constant < -200 { constant = -200 }
            if constant > 0   { constant =  0  }
            
            
            self.topConstraint.constant = max(constant, 0-headerViewHeight)
            
//            scrollView.contentInset.top          = max(constant, 1-scrollInsentOffset) + scrollInsentOffset
//            scrollView.scrollIndicatorInsets.top = max(constant, 1-scrollInsentOffset) + scrollInsentOffset
            
            naviScrollOldVal      = offsetY
            naviScrollOldConstant = constant
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        println("scrollViewWillEndDragging \(velocity.y)")
        println("scrollViewWillEndDragging \(targetContentOffset.memory.y)")
        
        if velocity.y == 0 {
        
            let offsetY = scrollView.contentOffset.y
            if scrollView.contentSize.height < offsetY { return }
            if offsetY >= 0 {
                
                let constant = self.topConstraint.constant
                println(constant)
                if constant  < -headerViewHeight { return }
                if constant >= 0 { return }
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.topConstraint.constant = constant < -self.headerViewHeight/2 ? -self.headerViewHeight : 0
                    self.view.layoutIfNeeded()
                });
                
            }
        }
    }
}
