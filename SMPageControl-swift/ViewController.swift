//
//  ViewController.swift
//  SMPageControl-swift
//
//  Created by issam on 13/06/2016.
//  Copyright © 2016 issam khalloufi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var spacePageControl1: SMPageControl!
    @IBOutlet var spacePageControl2: SMPageControl!
    @IBOutlet var spacePageControl3: SMPageControl!
    @IBOutlet var spacePageControl4: SMPageControl!
    @IBOutlet var spacePageControl5: SMPageControl!
    @IBOutlet var spacePageControl6: SMPageControl!
    @IBOutlet var spacePageControl7: SMPageControl!
    @IBOutlet var spacePageControl8: SMPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        spacePageControl1.numberOfPages = 10
        spacePageControl2.numberOfPages = 10
        spacePageControl3.numberOfPages = 10
        spacePageControl4.numberOfPages = 10
        spacePageControl5.numberOfPages = 10
        spacePageControl6.numberOfPages = 10
        spacePageControl7.numberOfPages = 10
        spacePageControl8.numberOfPages = 10
        
        spacePageControl2.indicatorMargin = 20.0
        spacePageControl2.indicatorDiameter = 10.0
        
        spacePageControl3.alignment = SMPageControlAlignmentLeft;
        spacePageControl4.alignment = SMPageControlAlignmentRight;
        
        spacePageControl5.setPageIndicatorImage(UIImage(named: "pageDot")!)
        spacePageControl5.setCurrentPageIndicatorImage(UIImage(named: "currentPageDot")!)
     
        spacePageControl6.setPageIndicatorImage(UIImage(named: "pageDot")!)
        spacePageControl6.setCurrentPageIndicatorImage(UIImage(named: "currentPageDot")!)
        spacePageControl6.setImage(UIImage(named: "searchDot")!, pageIndex: 0)
        spacePageControl6.setCurrentImage(UIImage(named: "currentSearchDot")!,pageIndex: 0)
        /*spacePageControl6.setImage(UIImage(named: "appleDot")!, pageIndex: 1)
        spacePageControl6.setCurrentImage(UIImage(named: "currentAppleDot")!,pageIndex: 1)
        spacePageControl6.setName("Search", pageIndex: 0)
        spacePageControl6.setName("Apple", pageIndex: 1)
        spacePageControl6.setCurrentPage(1)
        
        spacePageControl7.pageIndicatorTintColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.7)
        spacePageControl7.currentPageIndicatorTintColor = UIColor.yellowColor()
        spacePageControl7.setImageMask(UIImage(named: "appleMask")!, pageIndex: 1)
        spacePageControl7.setImageMask(UIImage(named: "searchMask")!, pageIndex: 0)

        spacePageControl8.pageIndicatorTintColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        spacePageControl8.currentPageIndicatorTintColor = UIColor.redColor()
        spacePageControl8.pageIndicatorMaskImage = UIImage(named: "appleMask")!*/
        
        
        
        spacePageControl1.addTarget(self, action: #selector(ViewController.spacePageControl(_:)), forControlEvents:  UIControlEvents.ValueChanged)
        spacePageControl2.addTarget(self, action: #selector(ViewController.spacePageControl(_:)), forControlEvents:  UIControlEvents.ValueChanged)
        spacePageControl3.addTarget(self, action: #selector(ViewController.spacePageControl(_:)), forControlEvents:  UIControlEvents.ValueChanged)
        spacePageControl4.addTarget(self, action: #selector(ViewController.spacePageControl(_:)), forControlEvents:  UIControlEvents.ValueChanged)
        spacePageControl5.addTarget(self, action: #selector(ViewController.spacePageControl(_:)), forControlEvents:  UIControlEvents.ValueChanged)
        spacePageControl6.addTarget(self, action: #selector(ViewController.spacePageControl(_:)), forControlEvents:  UIControlEvents.ValueChanged)
        spacePageControl7.addTarget(self, action: #selector(ViewController.spacePageControl(_:)), forControlEvents:  UIControlEvents.ValueChanged)
        spacePageControl8.addTarget(self, action: #selector(ViewController.spacePageControl(_:)), forControlEvents:  UIControlEvents.ValueChanged)

    }
    @IBAction func pageControl(sender:AnyObject){
          print("Current Page (UIPageControl : \(pageControl.currentPage))", terminator: "\n")
    }
    func spacePageControl(sender:SMPageControl) {
        print("Current Page (SMPageControl : \(sender.currentPage))", terminator: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

