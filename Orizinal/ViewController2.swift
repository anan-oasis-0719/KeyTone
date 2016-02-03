//
//  ViewController2.swift
//  Orizinal
//
//  Created by onda anan on 2016/02/03.
//  Copyright © 2016年 onda anan. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet var MusicSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MusicSwitch.addTarget(self, action: "onClickMySwicth:", forControlEvents: UIControlEvents.ValueChanged)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func onClickMySwicth(sender: UISwitch){
        
        if sender.on {
            
        }
        else {
           
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
