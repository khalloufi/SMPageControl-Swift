# SMPageControl-Swift

![Screenshot](https://github.com/khalloufi/SMPageControl-Swift/blob/master/Screens/Screen.png)

## Installation
Download the repository and add the file SMPageControl.swift to your project.

## Example Usage
``` Swift
@IBOutlet var spacePageControl1: SMPageControl!
```

``` Swift
pageControl.setPageIndicatorImage(UIImage(named: "pokemen_color")!)
pageControl.setCurrentPageIndicatorImage(UIImage(named: "pikatsho")!)
```

``` Swift
spacePageControl.pageIndicatorTintColor = UIColor.redColor().colorWithAlphaComponent(0.2)
spacePageControl.currentPageIndicatorTintColor = UIColor.redColor()
spacePageControl.setPageIndicatorMaskImage(UIImage(named: "Pokemon")!)
```
## License

SMPageControl is available under the MIT license.
