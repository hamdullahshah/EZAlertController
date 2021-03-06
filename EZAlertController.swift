//
//  EZAlertView.swift
//  EZAlertView
//
//  Created by Furkan Yilmaz on 11/11/15.
//  Copyright © 2015 Furkan Yilmaz. All rights reserved.
//

import UIKit

public class EZAlertController {

    //==========================================================================================================
    // MARK: - Singleton
    //==========================================================================================================

    class var instance : EZAlertController {
        struct Static {
            static let inst : EZAlertController = EZAlertController ()
        }
        return Static.inst
    }

    //==========================================================================================================
    // MARK: - Private Functions
    //==========================================================================================================

    private func topMostController() -> UIViewController {
        var topController = (UIApplication.sharedApplication().keyWindow!.rootViewController)!
        while let presentedVC = topController.presentedViewController {
            topController = presentedVC
        }
        return topController
    }


    //==========================================================================================================
    // MARK: - Class Functions
    //==========================================================================================================

    public class func alert(title: String) -> UIAlertController {
        return alert(title, message: "")
    }

    public class func alert(title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK") { () -> () in
            // Do nothing
        }
    }

    public class func alert(title: String, message: String, acceptMessage: String, acceptBlock: () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .Default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)

        instance.topMostController().presentViewController(alert, animated: true, completion: nil)
        return alert
    }

    public class func alert(title: String, message: String, cancelBlock: () -> (), acceptBlock: () -> ()) -> UIAlertController {
        return alert(title, message: message, leftButtonMessage: "Cancel", rightButtonMessage: "Accept", leftBlock: { () -> () in
            cancelBlock()
            }) { () -> () in
                acceptBlock()
        }
    }

    public class func alert(title: String, message: String, leftButtonMessage: String, rightButtonMessage: String, leftBlock: () -> (), rightBlock: () -> ()) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let declineButton = UIAlertAction(title: leftButtonMessage, style: .Default, handler: { (action: UIAlertAction) in
            leftBlock()
        })
        let acceptButton = UIAlertAction(title: rightButtonMessage, style: .Default, handler: { (action: UIAlertAction) in
            rightBlock()
        })
        alert.addAction(declineButton)
        alert.addAction(acceptButton)

        instance.topMostController().presentViewController(alert, animated: true, completion: nil)
        return alert
    }

    public class func actionSheet(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        for action in actions {
            alert.addAction(action)
        }
        instance.topMostController().presentViewController(alert, animated: true, completion: nil)
    }
    
    public class func alert(title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController().presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
    public class func actionSheet(title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController().presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
}


extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .Default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex++
            self.addAction(action)
        }
    }
}



extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertActionStyle, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, style: style) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}
