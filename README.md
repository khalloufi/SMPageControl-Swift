# SMPageControl-Swift


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