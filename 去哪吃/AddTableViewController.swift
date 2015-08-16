//
//  AddTableViewController.swift
//  去哪吃
//
//  Created by baby on 15/2/17.
//  Copyright (c) 2015年 Beijing Gold Finger Education Technology LLC. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController,UITextFieldDelegate {
    
    
    
    var placeNames:[String]!
    var countArray:[Int]!
    var countNumber = 0
    var nameTextfields = [UITextField()]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        countArray = [0]
        
        placeNames = [String]()
        //取回原数据
        if let place1: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("place") {
            placeNames = place1 as! [String]
        }
        
        countNumber = placeNames.count
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tap)
        //println(nameTextfields)
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        */
    }
    /* 
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification:NSNotification){
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification){
        adjustInsetForKeyboardShow(false, notification: notification)

    }
    
    func adjustInsetForKeyboardShow(show:Bool, notification:NSNotification){
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        let adjustHeight = CGRectGetHeight(keyboardFrame) * (show ? 1:-1)
        tableView.contentInset.bottom += adjustHeight
        tableView.scrollIndicatorInsets.bottom += adjustHeight
    }
    */
    
    func tap(sender:UITapGestureRecognizer){
        tableView.viewWithTag(100)?.resignFirstResponder()
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return countArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        print(indexPath)
        //通过tag值取文本输入框，并设置代理
        let textField = cell.viewWithTag(100) as! UITextField
        nameTextfields.append(textField)
        if nameTextfields[0].frame == CGRectZero {
            nameTextfields.removeAtIndex(0)
        }
        //println(nameTextfields.count)
        //textField.delegate = self
        textField.becomeFirstResponder()
        return cell
    
    }
    

    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       
        //在footerview中插入按钮和文字，并添加事件
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        view.backgroundColor = UIColor.clearColor()
        let addButton = UIButton(frame: CGRectMake(12, 5, 28, 28))
        addButton.addTarget(self, action: "addRow:", forControlEvents: UIControlEvents.TouchUpInside)
        addButton.setImage(UIImage(named: "addButton_small"), forState: UIControlState.Normal)
        let lable = UILabel(frame: CGRectMake(54, 5, 200, 30))
        lable.text = "继续添加"
        lable.font = UIFont.systemFontOfSize(14)
        let tapGuesture = UITapGestureRecognizer(target: self, action: "addRow:")
        view.addGestureRecognizer(tapGuesture)
        view.addSubview(lable)
        view.addSubview(addButton)
        return view
    }
    
    
    //插入行
    func addRow(sender:AnyObject) {
        
        countArray.append(0)

        //tableView.setEditing(true, animated: true)//设置cell为可编辑
        
        self.tableView.beginUpdates()
        let indexPath = NSIndexPath(forRow: countArray.count-1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths(NSArray(object: indexPath) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
        self.tableView.endUpdates()
        

    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //删除单元格
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            countArray.removeAtIndex(indexPath.row)
            nameTextfields.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            //println(self.placeNames)
        }

    }
    
}
