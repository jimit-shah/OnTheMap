//
//  BorderedButton.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/1/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {

  // MARK: Properties
  
  // constants for styling and configuration
  let darkerBlue = UIColor(red: 0.012, green: 0.600, blue: 0.898, alpha:1.0)
  let lighterBlue = UIColor(red: 0.012, green: 0.706, blue: 0.898, alpha: 1.0)
  
//  let lighterBlue = UIColor(red: 0.0, green: 0.180, blue: 0.229, alpha: 1.0)
  let titleLabelFontSize: CGFloat = 17.0
  let borderedButtonHeight: CGFloat = 44.0
  let borderedButtonCornerRadius: CGFloat = 4.0
  let phoneBorderedButtonExtraPadding: CGFloat = 14.0
  
  var backingColor: UIColor? = nil
  var highlightedBackingColor: UIColor? = nil
  
  // MARK: Initialization
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    themeBorderedButton()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    themeBorderedButton()
  }
  
  private func themeBorderedButton() {
    layer.masksToBounds = true
    layer.cornerRadius = borderedButtonCornerRadius
    highlightedBackingColor = darkerBlue
    backingColor = darkerBlue
    backgroundColor = lighterBlue
    setTitleColor(.white, for: UIControlState())
    titleLabel?.font = UIFont.systemFont(ofSize: titleLabelFontSize)
  }
  
  // MARK: Setters
  
  func setBackingColor(_ newBackingColor: UIColor) {
    if let _ = backingColor {
      backingColor = newBackingColor
      backgroundColor = newBackingColor
    }
  }
  
  private func setHighlightedBackingColor(_ newHighlightedBackingColor: UIColor) {
    highlightedBackingColor = newHighlightedBackingColor
    backingColor = highlightedBackingColor
  }
  
  // MARK: Tracking
  
  override func beginTracking(_ touch: UITouch, with withEvent: UIEvent?) -> Bool {
    backgroundColor = highlightedBackingColor
    return true
  }
  
  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    backgroundColor = backingColor
  }
  
  override func cancelTracking(with event: UIEvent?) {
    backgroundColor = backingColor
  }
  
  // MARK: Layout
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
    var sizeThatFits = CGSize.zero
    sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
    sizeThatFits.height = borderedButtonHeight
    return sizeThatFits
  }
  
}
