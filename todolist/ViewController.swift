//
//  ViewController.swift
//  todolist
//
//  Created by Steven Cassidy on 2/16/16.
//  Copyright © 2016 Steven Cassidy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var tasks = NSArray()

  @IBOutlet weak var tableView: UITableView!
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count;
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
    let description = String(tasks[indexPath.row].objectForKey("description")!)
    cell.textLabel?.text = description
    return cell
  }

  func showJSON(data:NSData) {
    do {
      let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
      tasks = jsonResult
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.tableView.reloadData()
      })
    } catch {
      print("Fetch failed: \((error as NSError).localizedDescription)")
    }
  }

  func loadTasks() {
    let url = NSURL(string:"http://localhost:3000/tasks")!
    print("Will call \(url)")
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
      self.showJSON(data!)
    }
    task.resume()
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    loadTasks()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

