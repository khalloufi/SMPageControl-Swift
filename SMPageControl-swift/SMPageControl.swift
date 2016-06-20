//
//  SMPageControl.swift
//  SMPageControl-swift
//
//  Created by issam on 13/06/2016.
//  Copyright © 2016 issam khalloufi. All rights reserved.
//

import UIKit
struct SMPageControlAlignment {
    var value: UInt32
    init(_ val: UInt32) { value = val }
}
let SMPageControlAlignmentLeft = SMPageControlAlignment(0)
let SMPageControlAlignmentCenter = SMPageControlAlignment(1)
let SMPageControlAlignmentRight = SMPageControlAlignment(2)

struct SMPageControlVerticalAlignment {
    var value: UInt32
    init(_ val: UInt32) { value = val }
}
let SMPageControlVerticalAlignmentTop = SMPageControlVerticalAlignment(0)
let SMPageControlVerticalAlignmentMiddle = SMPageControlVerticalAlignment(1)
let SMPageControlVerticalAlignmentBottom = SMPageControlVerticalAlignment(2)

struct SMPageControlTapBehavior {
    var value: UInt32
    init(_ val: UInt32) { value = val }
}
let SMPageControlTapBehaviorStep = SMPageControlTapBehavior(0)
let SMPageControlTapBehaviorJump = SMPageControlTapBehavior(1)

struct SMPageControlImageType {
    var value: UInt32
    init(_ val: UInt32) { value = val }
}
let SMPageControlImageTypeNormal = SMPageControlImageType(0)
let SMPageControlImageTypeCurrent = SMPageControlImageType(1)
let SMPageControlImageTypeMask = SMPageControlImageType(2)


let DEFAULT_INDICATOR_WIDTH:CGFloat = 6.0
let DEFAULT_INDICATOR_MARGIN:CGFloat = 10.0

let DEFAULT_INDICATOR_WIDTH_LARGE:CGFloat = 7.0
let DEFAULT_INDICATOR_MARGIN_LARGE:CGFloat = 9.0
let DEFAULT_MIN_HEIGHT_LARGE:CGFloat =  36.0


class SMPageControl: UIControl {
    var numberOfPages:NSInteger = 0
    var currentPage:NSInteger = 0
    var indicatorMargin:CGFloat = 0
    var indicatorDiameter:CGFloat = 0
    var minHeight:CGFloat = 0
    
    var alignment:SMPageControlAlignment = SMPageControlAlignmentCenter
    var verticalAlignment:SMPageControlVerticalAlignment = SMPageControlVerticalAlignmentMiddle
    
    var pageIndicatorImage:UIImage!
    var pageIndicatorMaskImage:UIImage!
    var pageIndicatorTintColor:UIColor!
    
    var currentPageIndicatorImage:UIImage!
    var currentPageIndicatorTintColor:UIColor!
    
    var hidesForSinglePage:Bool = false
    var defersCurrentPageDisplay:Bool = false
    
    var tapBehavior:SMPageControlTapBehavior = SMPageControlTapBehaviorStep
    
    var displayedPage:NSInteger = 0
    var measuredIndicatorWidth:CGFloat = 0
    var measuredIndicatorHeight:CGFloat = 0
    var pageImageMask:CGImageRef!
    
    var pageNames = [NSInteger: String]()
    var pageImages = [NSInteger: UIImage]()
    var currentPageImages = [NSInteger: UIImage]()
    var pageImageMasks = [NSInteger: UIImage]()
    var cgImageMasks = [NSInteger: CGImageRef]()
    var pageRects = [CGRect]()
    
    var accessibilityPageControl:UIPageControl = UIPageControl.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialize()
    }
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (frame) {
            super.frame = frame
            setNeedsDisplay()
        }
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        if (numberOfPages < 2 && hidesForSinglePage) {
            return;
        }
        let context = UIGraphicsGetCurrentContext()
        var _pageRects = [CGRect]()
        let left:CGFloat = leftOffset()
        var xOffset:CGFloat = left
        var yOffset:CGFloat = 0.0
        var fillColor:UIColor
        var image:UIImage?
        var maskingImage:CGImageRef?
        var maskSize:CGSize = CGSizeZero
        
        for indexNumber in 0..<numberOfPages {
            if (indexNumber == displayedPage) {
                fillColor = (currentPageIndicatorTintColor != nil) ? currentPageIndicatorTintColor : UIColor.whiteColor()
                image = currentPageImages[indexNumber]
                if  nil == image {
                    image = currentPageIndicatorImage
                }
            } else {
                fillColor = (pageIndicatorTintColor != nil) ? pageIndicatorTintColor : UIColor.whiteColor().colorWithAlphaComponent(0.3)
                image = pageImages[indexNumber]
                if nil == image {
                    image = pageIndicatorImage
                }
            }
            // If no finished images have been set, try a masking image
            if nil == image {
                if let originalImage:UIImage = pageImageMasks[indexNumber]{
                    maskSize = originalImage.size
                }
                
                maskingImage = cgImageMasks[indexNumber]
                // If no per page mask is set, try for a global page mask!
                if (nil == maskingImage) {
                    maskingImage = pageImageMask
                    if pageIndicatorMaskImage != nil{
                        maskSize = pageIndicatorMaskImage.size
                    }
                }
            }
            fillColor.set()
            var indicatorRect:CGRect;
            if (image != nil) {
                yOffset = topOffsetForHeight(image!.size.height,rect: rect)
                let centeredXOffset:CGFloat = xOffset + floor((measuredIndicatorWidth - image!.size.width) / 2.0)
                image!.drawAtPoint(CGPointMake(centeredXOffset, yOffset))
                indicatorRect = CGRectMake(centeredXOffset, yOffset, image!.size.width, image!.size.height)
            } else if (maskingImage != nil) {
                yOffset = topOffsetForHeight(maskSize.height,rect: rect)
                let centeredXOffset:CGFloat = xOffset + floor((measuredIndicatorWidth - maskSize.width) / 2.0)
                indicatorRect = CGRectMake(centeredXOffset, yOffset, maskSize.width, maskSize.height)
                CGContextDrawImage(context, indicatorRect, maskingImage)
            } else {
                yOffset = topOffsetForHeight(indicatorDiameter,rect: rect)
                let centeredXOffset:CGFloat = xOffset + floor((measuredIndicatorWidth - indicatorDiameter) / 2.0);
                indicatorRect = CGRectMake(centeredXOffset, yOffset, indicatorDiameter, indicatorDiameter);
                CGContextFillEllipseInRect(context, indicatorRect)
            }
            _pageRects.append(indicatorRect)
            maskingImage = nil
            xOffset += measuredIndicatorWidth + indicatorMargin;
        }

        pageRects = _pageRects;
    }
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
        setStyleWithDefaults()
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently
        self.contentMode = UIViewContentMode.Redraw
    }
    func updateCurrentPageDisplay(){
        displayedPage = currentPage
        self.setNeedsLayout()
    }
    func leftOffset() -> CGFloat {
        let rect:CGRect = self.bounds;
        let size:CGSize = sizeForNumberOfPages(numberOfPages)
        if alignment.value == SMPageControlAlignmentCenter.value {
            return ceil(CGRectGetMidX(rect) - CGFloat(size.width / 2.0))
        }
        if alignment.value == SMPageControlAlignmentRight.value {
            return CGRectGetMaxX(rect) - size.width
        }
        return 0;
    }
    func topOffsetForHeight(height:CGFloat, rect:CGRect) -> CGFloat {
        if verticalAlignment.value == SMPageControlVerticalAlignmentMiddle.value{
            return CGRectGetMidY(rect) - (height / 2.0);
        }
        if verticalAlignment.value == SMPageControlVerticalAlignmentBottom.value{
            return CGRectGetMaxY(rect) - height;
        }
        return 0;
    }
    func sizeForNumberOfPages(pageCount:NSInteger) -> CGSize {
        let marginSpace = CGFloat(max(0,pageCount - 1)) * indicatorMargin
        let indicatorSpace = CGFloat(pageCount) * measuredIndicatorWidth
        return CGSizeMake(marginSpace + indicatorSpace, measuredIndicatorHeight)
    }
    func rectForPageIndicator(pageIndex : NSInteger) -> CGRect {
        if (pageIndex < 0 || pageIndex >= numberOfPages) {
            return CGRectZero;
        }
        let left:CGFloat = leftOffset()
        let size:CGSize =  sizeForNumberOfPages(pageIndex + 1)
        return CGRectMake(left + size.width - measuredIndicatorWidth, 0, measuredIndicatorWidth, measuredIndicatorWidth)
    }
    func setImage(image:UIImage!,pageIndex:NSInteger,type:SMPageControlImageType){
        if (pageIndex < 0 || pageIndex >= numberOfPages) {
            return;
        }
        switch type.value {
            case SMPageControlImageTypeCurrent.value:
                if (image != nil){
                    currentPageImages[pageIndex] = image
                }else{
                    currentPageImages.removeValueForKey(pageIndex)
                }
                break
            case SMPageControlImageTypeNormal.value:
                if (image != nil){
                    pageImages[pageIndex] = image
                }else{
                    pageImages.removeValueForKey(pageIndex)
                }
                break
            case SMPageControlImageTypeMask.value:
                if (image != nil){
                    pageImageMasks[pageIndex] = image
                }else{
                    pageImageMasks.removeValueForKey(pageIndex)
                }
                break
            default:
                break
        }
        
    }
    func setImage(image:UIImage, pageIndex:NSInteger){
        setImage(image, pageIndex: pageIndex, type: SMPageControlImageTypeNormal)
        updateMeasuredIndicatorSizes()
    }
    func setCurrentImage(image:UIImage,pageIndex:NSInteger){
        setImage(image, pageIndex: pageIndex, type: SMPageControlImageTypeCurrent)
        updateMeasuredIndicatorSizes()
    }
    func setImageMask(image:UIImage?, pageIndex:NSInteger) {
        setImage(image, pageIndex: pageIndex, type: SMPageControlImageTypeMask)

        if nil == image{
            cgImageMasks.removeValueForKey(pageIndex)
            return
        }
        cgImageMasks[pageIndex] = createMaskForImage(image!)
        updateMeasuredIndicatorSizeWithSize(image!.size)
        setNeedsDisplay()
}
    override func sizeThatFits(size:CGSize) -> CGSize {
        var sizeThatFits:CGSize = sizeForNumberOfPages(numberOfPages)
        sizeThatFits.height = max(sizeThatFits.height,minHeight)
        return sizeThatFits
    }
    override func intrinsicContentSize() -> CGSize {
        if (numberOfPages < 1 || (numberOfPages < 2 && hidesForSinglePage)) {
            return CGSizeMake(UIViewNoIntrinsicMetric, 0.0)
        }
        return CGSizeMake(UIViewNoIntrinsicMetric, max(measuredIndicatorHeight, minHeight))
    }
    func updatePageNumberForScrollView(scrollView:UIScrollView) {
        currentPage = NSInteger(floor(scrollView.contentOffset.x / scrollView.bounds.size.width));
    }
    func setScrollViewContentOffsetForCurrentPage(scrollView:UIScrollView,animated:Bool){
        var offset:CGPoint = scrollView.contentOffset
        offset.x = scrollView.bounds.size.width * CGFloat(currentPage)
        scrollView.setContentOffset(offset, animated: animated)
    }
    func setStyleWithDefaults() {
        setIndicatorDiameter(DEFAULT_INDICATOR_WIDTH_LARGE)
        setIndicatorMargin(DEFAULT_INDICATOR_MARGIN_LARGE)
        pageIndicatorTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        setMinHeight(DEFAULT_MIN_HEIGHT_LARGE)
    }
    //MARK :
    func createMaskForImage(image:UIImage) -> CGImageRef {
        let pixelsWide = image.size.width * image.scale
        let pixelsHigh = image.size.height * image.scale
        let context:CGContextRef = CGBitmapContextCreate(nil,
                                               Int(pixelsWide),
                                               Int(pixelsHigh),
                                               CGImageGetBitsPerComponent(image.CGImage),
                                               Int(pixelsWide),
                                               nil,
                                               CGImageAlphaInfo.Only.rawValue)!
        CGContextTranslateCTM(context, 0.0, pixelsHigh)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGRectMake(0, 0, pixelsWide, pixelsHigh), image.CGImage)
        let maskImage:CGImageRef =  CGBitmapContextCreateImage(context)!
        return maskImage
    }
    
    func updateMeasuredIndicatorSizeWithSize(size:CGSize){
        measuredIndicatorWidth = max(measuredIndicatorWidth, size.width);
        measuredIndicatorHeight = max(measuredIndicatorHeight, size.height);
    }
    
    func updateMeasuredIndicatorSizes(){
        measuredIndicatorWidth = indicatorDiameter;
        measuredIndicatorHeight = indicatorDiameter;
        // If we're only using images, ignore the indicatorDiameter
        if ((pageIndicatorImage != nil || pageIndicatorMaskImage != nil) && currentPageIndicatorImage != nil)
        {
            measuredIndicatorWidth = 0;
            measuredIndicatorHeight = 0;
        }
        
        if (pageIndicatorImage != nil) {
            updateMeasuredIndicatorSizeWithSize(pageIndicatorImage.size)
        }
        
        if (currentPageIndicatorImage != nil) {
            updateMeasuredIndicatorSizeWithSize(currentPageIndicatorImage.size)
        }
        
        if (pageIndicatorMaskImage != nil) {
            updateMeasuredIndicatorSizeWithSize(pageIndicatorMaskImage.size)
        }
        invalidateIntrinsicContentSize()
    }
    @nonobjc
    func setIndicatorDiameter(_indicatorDiameter:CGFloat) {
        if (_indicatorDiameter == indicatorDiameter) {
            return
        }
        indicatorDiameter = _indicatorDiameter
         // Absolute minimum height of the control is the indicator diameter
        if (minHeight < indicatorDiameter) {
            setMinHeight(indicatorDiameter)
        }
        updateMeasuredIndicatorSizes()
        setNeedsDisplay()
    }
    @nonobjc
    func setIndicatorMargin(_indicatorMargin:CGFloat) {
        if (_indicatorMargin == indicatorMargin) {
            return
        }
        indicatorMargin = _indicatorMargin;
        setNeedsDisplay()
    }
    @nonobjc
    func setMinHeight(_minHeight:CGFloat) {
        if (_minHeight == minHeight) {
            return
        }
        minHeight = _minHeight
        if (minHeight < indicatorDiameter) {
            minHeight = indicatorDiameter
        }
        
        invalidateIntrinsicContentSize()
        setNeedsLayout()

    }
    @nonobjc
    func setNumberOfPages(_numberOfPages:NSInteger) {
        if _numberOfPages == numberOfPages {
            return;
        }
        accessibilityPageControl.numberOfPages = _numberOfPages
        numberOfPages = _numberOfPages
        self.invalidateIntrinsicContentSize()
        updateAccessibilityValue()
        setNeedsDisplay()
    }
    @nonobjc
    func setCurrentPage(_currentPage:NSInteger) {
        setCurrentPage(_currentPage, sendEvent: false, canDefer: false)
    }
    func setCurrentPage(_currentPage:NSInteger,sendEvent:Bool,canDefer:Bool) {
        currentPage = min(max(0,_currentPage),numberOfPages - 1)
        accessibilityPageControl.currentPage = currentPage

        updateAccessibilityValue()
        
        if self.defersCurrentPageDisplay == false || canDefer == false{
            displayedPage = currentPage
            setNeedsDisplay()
        }
        if sendEvent{
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }

    @nonobjc
    func setCurrentPageIndicatorImage(_currentPageIndicatorImage:UIImage) {
        if _currentPageIndicatorImage.isEqual(currentPageIndicatorImage) {
            return;
        }
        currentPageIndicatorImage = _currentPageIndicatorImage
        updateMeasuredIndicatorSizes()
        setNeedsDisplay()
    }

    @nonobjc
    func setPageIndicatorImage(_pageIndicatorImage:UIImage) {
        if _pageIndicatorImage.isEqual(pageIndicatorMaskImage){
            return
        }
        pageIndicatorImage = _pageIndicatorImage
        updateMeasuredIndicatorSizes()
        setNeedsDisplay()
    }
    
    @nonobjc
    func setPageIndicatorMaskImage(_pageIndicatorMaskImage:UIImage) {
        if _pageIndicatorMaskImage.isEqual(pageIndicatorMaskImage){
          return
        }
        pageIndicatorMaskImage = _pageIndicatorMaskImage
        pageImageMask = createMaskForImage(pageIndicatorMaskImage)
        updateMeasuredIndicatorSizes()
        setNeedsDisplay()
    }
    // MARK : UIAccessibility
    func setName(name:String,pageIndex:NSInteger) {
        if (pageIndex < 0 || pageIndex >= numberOfPages) {
            return;
        }
        pageNames[pageIndex] = name;
    }
    func nameForPage(pageIndex:NSInteger) -> String? {
        if (pageIndex < 0 || pageIndex >= numberOfPages) {
            return nil;
        }
        return pageNames[pageIndex];
    }
    
    func updateAccessibilityValue() {
        let pageName = nameForPage(currentPage)
        if pageName != nil{
            self.accessibilityValue = "\(pageName) - \(accessibilityPageControl.accessibilityValue)"
        }else{
            self.accessibilityValue = accessibilityPageControl.accessibilityValue
        }
    }
   // MARK : Tap Gesture
    // We're using touchesEnded: because we want to mimick UIPageControl as close as possible
    // As of iOS 6, UIPageControl still (as far as we know) does not use a tap gesture recognizer. This means that actions like
    // touching down, sliding around, and releasing, still results in the page incrementing or decrementing.
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch!.locationInView(self)
        if(SMPageControlTapBehaviorJump.value == tapBehavior.value){
            var tappedIndicatorIndex:NSInteger = NSNotFound
            for (index, value) in pageRects.enumerate() {
                let indicatorRect:CGRect = value
                if CGRectContainsPoint(indicatorRect, point){
                    tappedIndicatorIndex = index
                    break
                }
            }
            if NSNotFound != tappedIndicatorIndex{
                setCurrentPage(tappedIndicatorIndex, sendEvent: true, canDefer: true)
                return
            }
        }
        let size = sizeForNumberOfPages(numberOfPages)
        let left = leftOffset()
        let middle = left + (size.width / 2)
        if point.x < middle{
            setCurrentPage(currentPage - 1, sendEvent: true, canDefer: true)
        }else{
            setCurrentPage(currentPage + 1, sendEvent: true, canDefer: true)
        }
    }
}
