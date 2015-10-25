//
//  ViewController.swift
//  去哪吃
//
//  Created by baby on 15/2/16.
//  Copyright (c) 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit
import AFNetworking
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var backgrounImage: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    var placeNames:[String]!
    var number = 0
    var numberOfPlace = 0
    var numberOfchecked = 0
    var numberOfTemp = 0
    var checkedName:[String] = [""]
    var tempString:[String] = []
    
    lazy var clmanager = CLLocationManager()
    var location:String?
    //var deals:NSMutableArray!
    var shops:NSMutableArray!


    @IBOutlet weak var tips: UILabel!
    
    @IBOutlet weak var chopsticks: UIImageView!
    @IBOutlet weak var bowl: SpringImageView!
    @IBOutlet weak var addLable: DesignableLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clmanager.delegate = self
        clmanager.startUpdatingLocation()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        backgrounImage.addSubview(blurView)
        
//        placeNames = [String]()
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        tips.hidden = true
        //number = placeNames.count
        addButton.hidden = true
        chopsticks.hidden = false
        bowl.hidden = false
        addLable.text = "摇一摇"
        chopsticks.layer.anchorPoint = CGPointMake(0, 0)
        
//        addButton.bringSubviewToFront(view)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = "\(locations.last!.coordinate.longitude)" + "," + "\(locations.last!.coordinate.latitude)"
        if locations.count > 0 {
            manager.stopUpdatingLocation()
        }
        requestShops()
    }
    
    /*
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //如果数据不为空的时候取得数据给数组
        if let place1: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("place") {
            placeNames = place1 as? [String]
        }
        numberOfPlace = placeNames.count
        
        if let checked: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("checked") {
            checkedName = (checked as? [String])!
           // println(checkedName)
        }
        numberOfchecked = checkedName.count
        
        if let temp: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("temp") {
            tempString = (temp as? [String])!
        }
        numberOfTemp = tempString.count
        
        let identifier = "group.com.okjiaoyu.source.documents"
        let shareUserDefaults = NSUserDefaults(suiteName: identifier)
        if let shareUserDefaults = shareUserDefaults {
            shareUserDefaults.setObject(checkedName, forKey: "shareData")
            //println(checkedName)
        }
        
        //有无数据分别显示不同视图
        if numberOfPlace > 0 {
            addButton.hidden = true
            chopsticks.hidden = false
            bowl.hidden = false
            addLable.text = "摇一摇"
            chopsticks.layer.anchorPoint = CGPointMake(0, 0)
            
            
        }else{
            addButton.hidden = false
            chopsticks.hidden = true
            bowl.hidden = true
            addLable.text = "添加餐馆，摇一摇就去那"
        }
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true
        self.becomeFirstResponder()

    }

    override func viewDidAppear(animated: Bool) {
        if let checked: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("checked") {
            checkedName = checked as! [String]
            //println(checkedName)
        }
        numberOfchecked = checkedName.count
        if numberOfchecked == 0 && numberOfPlace > 0{
            addLable.text = "先选择餐馆，再摇一摇"
        }


    }
    */
    func requestShops(){
        let url = "http://apis.baidu.com/baidunuomi/openapi/searchshops"
        let params = NSMutableDictionary()
        params["city_id"] = 100010000
        params["cat_ids"] = "326"
//        params["subcat_ids"] = "962,994"
        params["location"] = location
        params["radius"] = 1000
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPAdditionalHeaders = ["apikey":"35ef1736690acaa25079a5e81794ee59"]
        sessionConfig.timeoutIntervalForRequest = 6
        let manager = AFHTTPSessionManager(sessionConfiguration: sessionConfig)
        manager.GET(url, parameters: params, success: { (_, data) -> Void in
            let result = data["data"] as! NSDictionary
            let shopsArray = result["shops"] as! NSArray
            self.shops = ShopsModel.objectArrayWithKeyValuesArray(shopsArray)
            }) { (_, error) -> Void in
                print(error)
        }

    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        //开始摇动
    }
    
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?) {
        //摇动取消
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        //摇动结束
        
        if event!.subtype == .MotionShake && self.shops.count > 0 {
        //发生的事情
        
        //取得随机数
        //getRandomNum()
        self.number = Int(arc4random_uniform(UInt32(self.shops.count)))
        //获取摇动结束后的餐馆
        let shake = CAKeyframeAnimation(keyPath: "transform.rotation")
        shake.duration = 0.7
        shake.repeatCount = 3
        shake.values = [0.0, -M_PI_2/2, 0.0, M_PI_2/2 ,0.0]
        shake.keyTimes = [0.0, 0.1, 0.2, 0.3, 0.4]
        self.chopsticks.layer.addAnimation(shake, forKey: nil)
        self.addLable.text = (self.shops[self.number] as! ShopsModel).shop_name
        self.addLable.animation = "fadeInDown"
        self.addLable.duration = 1
        self.addLable.delay = 2
        self.addLable.scaleX = 0.5
        self.addLable.scaleY = 0.5
        self.addLable.animate()
        
        
        self.bowl.animation = "shake"
        self.bowl.repeatCount = 3
        self.bowl.animate()
        }

    }
    
    /*//获得随机数
    func getRandomNum(){
        number = Int( Double(arc4random()) / Double(INT32_MAX) * Double(numberOfPlace) / 2)
    }
    */

    @IBAction func backToView (segue:UIStoryboardSegue) {
        //返回动作，通过segue渠道sourseVc
        let sourseVC = segue.sourceViewController as! AddTableViewController
        //let indexpath = sourseVC.tableView.indexPathForSelectedRow()
        //取消文本框的焦点
        sourseVC.tableView.viewWithTag(100)?.resignFirstResponder()
        
        for  textField in sourseVC.nameTextfields {
            if textField.text != "" {
                placeNames.append(textField.text!)
                checkedName.append(textField.text!)
                tempString.append(textField.text!)
            }
        }
        let count = placeNames.count - numberOfPlace
        //placeNames = sourseVC.placeNames
        if count > 0 {
            tips.text = "成功添加\(count)个餐馆"
            tips.hidden = false
            tips.alpha = 0
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.tips.alpha = 0.8
            })
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.tips.alpha = 0
            })
        }
        
        
        //println(placeNames)
        //将数据存入USdefault里面
        NSUserDefaults.standardUserDefaults().setObject(placeNames, forKey: "place")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSUserDefaults.standardUserDefaults().setObject(checkedName, forKey: "checked")
        NSUserDefaults.standardUserDefaults().synchronize()

        NSUserDefaults.standardUserDefaults().setObject(tempString, forKey: "temp")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let identifier = "group.com.okjiaoyu.source.documents"
        let shareUserDefaults = NSUserDefaults(suiteName: identifier)
        if let shareUserDefaults = shareUserDefaults {
            shareUserDefaults.setObject(checkedName, forKey: "shareData")
        }

        
    }
    
    @IBAction func cancel (segue:UIStoryboardSegue)
    {
        let sourseVC = segue.sourceViewController as! AddTableViewController
        sourseVC.tableView.viewWithTag(100)?.resignFirstResponder()
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "push"{
//            let pushAnimition = CATransition()
//            pushAnimition.type = kCATransitionPush
//            pushAnimition.subtype = kCATransitionFromLeft
//            self.navigationController?.view.layer.addAnimation(pushAnimition, forKey: kCATransition)            
//    }
//    }

}

