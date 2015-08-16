//
//  InterfaceController.swift
//  摇摇吃 WatchKit Extension
//
//  Created by baby on 15/5/2.
//  Copyright (c) 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var place: WKInterfaceLabel!

    var placeNames = [""]
    
    @IBAction func startShake() {
        let num = arc4random_uniform(UInt32(placeNames.count))
        let placename = placeNames[Int(num)]
        place.setText(placename)
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let identifier = "group.com.okjiaoyu.source.documents"
        let sharedUserDefaults = NSUserDefaults(suiteName: identifier)
        if let sharedUserDefaults = sharedUserDefaults {
            placeNames = sharedUserDefaults.objectForKey("shareData") as! [String]
        }
                        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
     

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
