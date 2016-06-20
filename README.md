# SMPageControl-Swift

![Screenshot](https://github.com/khalloufi/SMPageControl-Swift/blob/master/images/SMPageControl.png)

## Example Usage

``` Swift
SMPageControl pageControl = SMPageControl(frame: CGRect.zero)
pageControl.pageIndicatorTintColor = UIColor.redColor().colorWithAlphaComponent(0.2)
pageControl.currentPageIndicatorTintColor = UIColor.redColor()
pageControl.setPageIndicatorMaskImage(UIImage(named: "appleMask")!)
```

``` Swift
SMPageControl pageControl = SMPageControl(frame: CGRect.zero)
pageControl.pageIndicatorTintColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.7)
pageControl.currentPageIndicatorTintColor = UIColor.yellowColor()
pageControl.setImageMask(UIImage(named: "appleMask")!, pageIndex: 1)
pageControl.setImageMask(UIImage(named: "searchMask")!, pageIndex: 0)
```

``` Swift
SMPageControl pageControl = SMPageControl(frame: CGRect.zero)
pageControl.setCurrentPageIndicatorImage(UIImage(named: "currentPageDot")!)
pageControl.setImage(UIImage(named: "searchDot")!, pageIndex: 0)
pageControl.setCurrentImage(UIImage(named: "currentSearchDot")!,pageIndex: 0)
pageControl.setImage(UIImage(named: "appleDot")!, pageIndex: 1)
pageControl.setCurrentImage(UIImage(named: "currentAppleDot")!,pageIndex: 1)
pageControl.setName("Search", pageIndex: 0)
pageControl.setName("Apple", pageIndex: 1)

```