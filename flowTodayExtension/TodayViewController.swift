//
//  TodayViewController.swift
//  flowTodayExtension
//
//  Created by liuRuiLong on 15/12/5.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

import UIKit
import NotificationCenter
import NetToolKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var leftDayLabel: UILabel!
    @IBOutlet weak var netUseProgressView: UIProgressView!
    @IBOutlet weak var netUseDetail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NetTool.updateUseFlow()
        updateTodayFlowUI()
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "updateTodyFlow", userInfo: nil, repeats: true)
    }
    
    func updateTodyFlow(){
        NetTool.updateUseFlow()
        updateTodayFlowUI()
    }
    
    func updateTodayFlowUI(){
        let useFlow = NetTool.getHasUsedFlow()
        let allFlow = NetTool.getAllFlow()
        let userFlowStr = String(format: "%.2f", useFlow)
        let allFlowStr = String(format: "%.2f", allFlow);
        
        print("today use = \(userFlowStr) all user = (\(allFlowStr))")
        netUseProgressView.progress = Float(useFlow/allFlow)
        netUseDetail.text = "\(userFlowStr)/\(allFlowStr)"
        leftDayLabel.text = "还剩" + NetTool.getLeftTimeStr()
    }
    
    @IBAction func switchAct(sender: AnyObject) {
        let sw: UISwitch = sender as! UISwitch
        if sw.on{
            
        }else{
        
        }
    }
    
    @IBAction func openOrCloseWWAN(sender: AnyObject) {
        extensionContext?.openURL(NSURL(string: "prefs:root=MOBILE_DATA_SETTINGS_ID")!, completionHandler: nil)
    }
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
}
