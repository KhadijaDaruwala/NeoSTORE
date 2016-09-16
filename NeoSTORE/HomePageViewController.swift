//
//  SlideMenuViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 7/29/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //MARK: Variables & Arrays
    var scrollImageArray = [UIImage(named : "slider_img1.png"), UIImage(named : "slider_img2.png"), UIImage(named : "slider_img3.png"), UIImage(named : "slider_img4.png")]
    var collectionImageArray = [ "tableicon", "sofaicon", "chairsicon", "cupboardicon"]
    let screenSize: CGRect = UIScreen.mainScreen().bounds //gets the size of the screen
    
    //MARK: Outlets
    @IBOutlet weak var homePageControl: UIPageControl!
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        generateScrollView()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Custom navigation bar title
        self.navigationController?.navigationBar.topItem?.title = "NeoSTORE"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Gotham-Bold", size: 18)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    //Custom horizontal scroll view method
    func generateScrollView(){
        homeScrollView.showsHorizontalScrollIndicator = false
        let imageCount = scrollImageArray.count
        let screenWidth = screenSize.width
        
        //Sets the scroll view frame and puts image
        for(var i=0; i<imageCount; i += 1) {
            let xAxis  = CGFloat (i) * screenWidth;
            let scrollImage = UIImageView(image: scrollImageArray[i])
            scrollImage.frame = CGRectMake(xAxis , 0, screenWidth, self.homeScrollView.frame.size.height)
            self.homeScrollView.addSubview(scrollImage)
        }
        
        //Sets the size of the scroll view content
        self.homeScrollView.contentSize = CGSizeMake(screenWidth * CGFloat(imageCount) , 0)
        self.homeScrollView.pagingEnabled = true
        self.homePageControl.numberOfPages = scrollImageArray.count
    }
    
    //MARK: Scroll view delegate method
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = self.homeScrollView.frame.size.width
        let scrollPage = Int(round(scrollView.contentOffset.x / pageWidth))
        
        // Update the page control
        self.homePageControl.currentPage = scrollPage
    }
    
    //MARK: Collection view delegate methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionImageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HomeCollectionViewCell
        cell.collectionCellImage.image = UIImage(named: collectionImageArray[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var screenwidth : CGFloat
        var padding : CGFloat
        var itemWidth : CGFloat
        screenwidth = screenSize.width
        padding = 10.0 * 6;
        itemWidth = (screenwidth - padding) / 2.0;
        
        return CGSizeMake(itemWidth, itemWidth); // The size of one cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20); //Padding from all four sides - top, left , bottom , right
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        switch row {
            
        case 0:
           // let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            nextViewController.productID = "1"
            nextViewController.navigationTitle = "Tables"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        case 1:
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            nextViewController.productID = "3"
            nextViewController.navigationTitle = "Sofas"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        case 2:
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            nextViewController.productID = "2"
            nextViewController.navigationTitle = "Chairs"
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        case 3:
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductListingViewController") as! ProductListingViewController
            nextViewController.productID = "4"
            nextViewController.navigationTitle = "Cupboards"
            self.navigationController?.pushViewController(nextViewController, animated: true)
        default:
            print("Error")
        }
    }
}
