//
//  MyLanchTableViewController.swift
//  去哪吃
//
//  Created by baby on 15/2/18.
//  Copyright (c) 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class MyLanchTableViewController: UITableViewController {
    
    var placeNames:[String]!
    var checkedName:[String] = []
    var tempString:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取回原来数据
        placeNames = [String]()
        if let place1: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("place") {
            placeNames = place1 as! [String]
        }
        
        
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
      
        if placeNames.count == 0 {
            self.tableView.separatorStyle = .None
           
            let imageView = UIImageView(image: UIImage(named: "nocanguan"))
            let lable = UILabel(frame: CGRectMake(0, 0, 200, 40))
            lable.text = "你还未添加餐馆"

            self.view.addSubview(imageView)
            self.view.addSubview(lable)
            
            //自动布局
            let verticalCenter = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
            let HorizontalCenter = NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: -50)
            let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 123)
            let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 123)
            
            let topSpacing = NSLayoutConstraint(item: lable, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 20)
            let vertical = NSLayoutConstraint(item: lable, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
            
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            lable.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activateConstraints([verticalCenter,HorizontalCenter,widthConstraint,heightConstraint])
            NSLayoutConstraint.activateConstraints([topSpacing,vertical])
            
            
        }else{
            self.tableView.separatorStyle = .SingleLine
        }
        
        if let temp: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("temp") {
            tempString = temp as! [String]
        }
        

    }
    
    override func viewDidDisappear(animated: Bool) {
        for (_,value) in tempString.enumerate(){
            if value != ""{
                checkedName.append(value)
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(self.checkedName, forKey: "checked")
        NSUserDefaults.standardUserDefaults().synchronize()
        //println(checkedName)
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return placeNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = placeNames[indexPath.row]
        
        if tempString[indexPath.row] == ""
        {
            cell.accessoryType = .None
        }
        
        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //删除单元格
        if editingStyle == .Delete {
            placeNames.removeAtIndex(indexPath.row)
            tempString.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            NSUserDefaults.standardUserDefaults().setObject(self.placeNames, forKey: "place")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            NSUserDefaults.standardUserDefaults().setObject(self.tempString, forKey: "temp")
            NSUserDefaults.standardUserDefaults().synchronize()
            tableView.reloadData()

        }
        
      
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        let footerLable = UILabel(frame: CGRectMake(16, 0, 200, 30))
        footerLable.text = "打✓表示已选择"
        footerLable.textColor = UIColor.grayColor()
        footerLable.font = UIFont.systemFontOfSize(10)
        view.addSubview(footerLable)
        if placeNames.count == 0 {
            return nil
        }else{
            return view

        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
            tempString[indexPath.row] = placeNames[indexPath.row]
            
        }else{
            cell.accessoryType = .None
            tempString[indexPath.row] = ""
        }
        NSUserDefaults.standardUserDefaults().setObject(self.tempString, forKey: "temp")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
       // println(tempString)
        

    }
    



}
