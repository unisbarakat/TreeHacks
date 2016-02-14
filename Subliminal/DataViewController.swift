//
//  FirstViewController.swift
//  Subliminal
//
//  Created by Unis Barakat on 2/13/16.
//  Copyright © 2016 Unis Barakat. All rights reserved.
//

import UIKit
import Parse
import Charts


class DataViewController: UIViewController, ChartViewDelegate{
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var lineChart: LineChartView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    
    
    var days: [String]!
    var moodObjects = [PFObject]()
   
    
    var timer: NSTimer!

    
    
    
    
    
    @IBAction func chartChanged(sender: AnyObject) {
        
        if (segmentedControl.selectedSegmentIndex == 0){
            //            hours = ["00", "01", "02", "03", "04", "05", "06","07","08", "09", "10",
            //                "11", "12", "13", "14", "15", "16","17","18", "19", "20", "21", "22",
            //                "23"
            //            ]
            //            let moodIndex = [1.0,2.0,3.0,4.0,8.0,9.0,10.0,1.0,2.0,3.0,4.0,8.0,9.0,10.0,1.0,2.0,3.0,4.0,8.0,9.0,10.0,6.0,9.0,8.0]
            //
            loadData()
            
        } else if(segmentedControl.selectedSegmentIndex == 1){
            days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            let moodIndex = [1.0,2.0,3.0,4.0,8.0,9.0,10.0]
            
            
            setChart(days, values: moodIndex)
            
        }
        
        
        
        
    }
    
    
    
    @IBAction func saveChart(sender: AnyObject) {
        lineChart.saveToCameraRoll()
        
        let alert = UIAlertController(title: "Chart Saved!", message: "This chart has been saved to your Camera Roll.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.setRightBarButtonItem(addButton, animated: false)
        self.navigationItem.setLeftBarButtonItem(saveButton, animated: false)
        loadData()
            
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        
        
    }
    
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadData", object: nil)
//    }
    
    
    func loadData(){
        let moodQuery = PFQuery(className: "Mood")
        let date: NSDate = self.yesterDay()
        
        moodQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        moodQuery.orderByAscending("createdAt")
        moodQuery.whereKey("createdAt", greaterThan: date)
        moodQuery.includeKey("createdAt")
        
        
        var moodIndex: [Double] = [Double]()
        var hours: [String] = [String]()
        
        //source of khara
        moodQuery.findObjectsInBackgroundWithBlock { (results , error:NSError?) -> Void in
            if error == nil {
                let moods = results
                for mood in moods!{
                    moodIndex.append(mood["content"] as! Double)
                    hours.append((mood["hour"] as! String))
                    self.setChart(hours, values: moodIndex)

    
                }
                
            }
        }
        

    }
    
    
    
    
    
    
    
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Mood Index")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChart.data = lineChartData
        
        
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(days[entry.xIndex])")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    func yesterDay() -> NSDate {
        
        let today: NSDate = NSDate()
        
        let daysToAdd:Int = -1
        
        // Set up date components
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.day = daysToAdd
        
        // Create a calendar
        let gregorianCalendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let yesterDayDate: NSDate = gregorianCalendar.dateByAddingComponents(dateComponents, toDate: today, options:NSCalendarOptions(rawValue: 0))!
        
        return yesterDayDate
    }
    
    
    
}



