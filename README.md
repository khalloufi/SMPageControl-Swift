# SMPageControl-Swift

UIPageControl’s Fancy One-Upping Cousin.

Designers _love_ to make beautifully custom page controls that fit in with all the wood, gradients, and inner shadows they've worked so hard perfecting. 

Who can blame them?! SMPageControl makes it dead simple to give them what they want. Even better, SMPageControl is a _drop in_ replacement for UIPageControl. It mirrors all the functions of UIPageControl, with literally no changes beyond the class name.


[Apps Currently Using SMPageControl](https://github.com/Spaceman-Labs/SMPageControl/wiki/Apps)

**Using SMPageControl in your application? Let us know, and we'll add your app the list of apps!** <mailto:spaceman@spacemanlabs.com>

## Moar Customization!

SMPageControl has a variety of simple (yet powerful) areas of customization, and most all of them support the UIAppearance Proxy available to iOS 5.0 and newer.

* Indicator Size
* Indicator Spacing
* Indicator Alignment
* Images as Indicators
* Image Masks as Indicators
* Per-Indicator Customization
* Directly Tappable Indicators
* Extensive Support for UIAppearance
* Extended Support for UIAccessibility
* iOS 7 Ready

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

## UIAccessibility Additions

UIPageControl (like all Apple controls) provides out of the box support for UIAccessibility. The default behavior is to set the accessibility value to "page [current page + 1] of [number of pages]". e.g. "page 1 of 10"

SMPageControl provides the exact same functionality, but also allows you to name individual pages. This is extremely useful when using per page indicator images, where one or more page is likely to have a specific usage that is identifiable to the user.

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