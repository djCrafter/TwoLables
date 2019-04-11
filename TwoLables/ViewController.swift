//
//  ViewController.swift
//  TwoLables
//
//  Created by Crafter on 4/11/19.
//  Copyright © 2019 Crafter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var FirstLabel: UILabel!
    
    @IBOutlet weak var SecondLabel: UILabel!
    
    lazy var link = NSRange()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setTextOnFirstLabel()
       setTextOnSecondLabel()
    }
    
    func Concat (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        
        return result
    }
    
    
    func setTextOnFirstLabel(){
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.right
        
        let attributes1: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.red,
            .strokeWidth : 5.0,
            .font: UIFont(name: "Chalkduster", size: 18.0),
            .paragraphStyle: style
            ]
        let attributes2: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.blue,
            .strokeWidth : 5.0,
            .font: UIFont(name: "HelveticaNeue-CondensedBold", size: 21.0),
            .paragraphStyle: style
            ]
        
        let attributetext1 = NSAttributedString(string: "Hello ", attributes: attributes1)
        let attributetext2 = NSAttributedString(string: "World ", attributes: attributes2)
     
       FirstLabel.attributedText = Concat(left: attributetext1, right: attributetext2)
    }
    
    func setTextOnSecondLabel(){
        let str = "String is a link"
        link = (str as NSString).range(of: "link")
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.right
        
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body).withSize(20),
            .foregroundColor: UIColor.blue,
            .paragraphStyle: style
        ]
        
          let attributetext = NSMutableAttributedString(string: str, attributes: attribute)
          attributetext.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: link)
        
          SecondLabel.attributedText = attributetext
          SecondLabel.backgroundColor = UIColor.yellow
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
        SecondLabel.addGestureRecognizer(gesture)
    }
    
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: SecondLabel, inRange: link) {
            if SecondLabel.backgroundColor == UIColor.yellow {
                SecondLabel.backgroundColor = UIColor.green
            } else {
                SecondLabel.backgroundColor = UIColor.yellow
            }
        }
    }
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
