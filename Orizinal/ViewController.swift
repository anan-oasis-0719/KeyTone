//
//  ViewController.swift
//  Orizinal
//
//  Created by onda anan on 2015/10/30.
//  Copyright © 2015年 onda anan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    
    var audioPlayer = AVAudioPlayer()
    
    let musicArray:[String] = ["C","D","E","F","G","A","B",]
    var index: Int = 0 // ダイヤルで再生する音の添字
    let keytoneArray:[Int] = []//ここ大丈夫？？？
    var keytoneindex: Int! // viewDidLoadで設定する
    
    var keytonenumber: Int = 3
    var kaijonumber: Int = 3
    var zankinumber: Int = 3
    
    var SeikaiNumber: Int = 0
    
    let keytoneLevel: Int = 3 //３連の正解音
    var keyArray:[Int] = [] //３連の正解音を格納する配列
    var loopTimes: Int! = 0 // 残りのループ回数
    
    var selectArray: [Int] = [] // 選択した音の配列
    var selectindex: Int! //その要素数??
    
    @IBOutlet var hanteiLabel: UILabel!
    @IBOutlet var keytoneLabel: UILabel!
    @IBOutlet var zankiLabel: UILabel!
    @IBOutlet var BackImage: UIImageView!
    
    @IBOutlet var firstLabel:UILabel!
    @IBOutlet var secondLabel:UILabel!
    @IBOutlet var thirdLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //kyetoneindex = Int(arc4random_uniform(UInt32(7)))
        
        // 正解音の決定
        //        keytoneindex = Int(arc4random_uniform(UInt32(7)))
        keyArray = [] //　初期化
        for _ in 0 ..< keytoneLevel { //３なら３回ループ
            keyArray.append(Int(arc4random_uniform(UInt32(7))))
        }
        
        keytoneLabel.text = "×\(keytonenumber)"
        hanteiLabel.text = "音を聞いてください！"
        
        setMusic(keyArray[0])
        loopTimes = keytoneLevel - 1
        
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 右上：キートーンが押された時のメソッド
    @IBAction func keytone() {
        
        firstLabel.text = "リセットされました"
        secondLabel.text = "リセットされました"
        thirdLabel.text = "リセットされました"
        
        selectArray.removeAll()
        SeikaiNumber = 0
        kaijonumber = 3
        
        let alertController = UIAlertController(title: "リセットされました", message: "また最初から音を探してください", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        //キートーンの残り回数が１回以上あったら
        if keytonenumber > 0 {
            
            hanteiLabel.text = "音を聞いてください！"
            
            keytonenumber = keytonenumber - 1
            keytoneLabel.text = "×\(keytonenumber)"
            
            setMusic(keyArray[0])
            loopTimes = keytoneLevel - 1
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        } else { // 無かったら
            keytoneLabel.text = "0"
            hanteiLabel.text = "もう聞けません！"
        }
        
    }
    
    @IBAction func migi() {
        
        index = index + 1
        if index > 6 {
            index = 0
        }
        
        scales()
        
        let music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicArray[index], ofType: "mp3")!)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: music)
        
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @IBAction func hidari() {
        
        index = index - 1
        if index < 0 {
            index = 6
        }
        
        scales()
        
        let music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicArray[index], ofType: "mp3")!)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: music)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
    }
    
    @IBAction func onemore(){
        
        let music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicArray[index], ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: music)
        } catch {
            // couldn't load file :(
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        scales()
        
    }
    
    // 「決定」ボタンが押された時のメソッド
    @IBAction func Serect(){
        selectArray.append(index)
        
        print("selectArrayの個数\(selectArray.count)")
        print("keyArrayの個数\(keytoneArray.count)")
        print("seikaiNumber\(SeikaiNumber)")
        print("keyArray[" + String(SeikaiNumber) + "] = " + String(keyArray[SeikaiNumber]))
        print("selectArray[" + String(SeikaiNumber) + "] = " + String(selectArray[SeikaiNumber]))
        print("keyArray\(keyArray)")
        print("selectArray\(selectArray)")
        
        
        if selectArray[SeikaiNumber] == keyArray[SeikaiNumber] {
            SeikaiNumber = SeikaiNumber + 1
            
            print("正解！")
            
            hanteiLabel.text = "次の音を選んで「決定」せよ"
            
            kaijonumber = kaijonumber - 1
            
            Lock()
            
            
            let music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Quiz-Buzzer01-1", ofType: "mp3")!)
            
            
            
            do {
                
                audioPlayer = try AVAudioPlayer(contentsOfURL: music)
                
            } catch {
                
                // couldn't load file :(
                
            }
            
            audioPlayer.prepareToPlay()
            
            audioPlayer.play()
            
        }else {
            
            hanteiLabel.text = "違います！"
            print("不正解")
            
            let music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Quiz-Wrong_Buzzer02-3", ofType: "mp3")!)
            
            
            
            do {
                
                audioPlayer = try AVAudioPlayer(contentsOfURL: music)
                
            } catch {
                
                // couldn't load file :(
                
            }
            
            //audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            let secondCheck = selectArray.isEmpty
            
            if secondCheck != true {
                selectArray.removeLast()
            }
            
            
            zankinumber = zankinumber-1
            
            if zankinumber <= 0 {
                
                performSegueWithIdentifier("a",sender: nil)
                
                //ゲームオーバー画面に遷移
                
            }
            
            if zankinumber  == 1 {
                
                zankiLabel.textColor = UIColor.redColor()
                
            }
                
            else if zankinumber  == 2 {
                
                zankiLabel.textColor = UIColor.orangeColor()
                
            }
            
            zankiLabel.text = "残機×\(zankinumber)"
            
        }
        
        if SeikaiNumber == 3 {
            
            performSegueWithIdentifier("b",sender: nil)
            let music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("nc48321", ofType: "wav")!)
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: music)
            } catch {
                // couldn't load file :(
            }
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    func setMusic(index: Int){
        //再生する音源のURLを生成.
        let soundFilePath : NSString = NSBundle.mainBundle().pathForResource(musicArray[index],ofType:
            "mp3")!
        let fileURL : NSURL = NSURL(fileURLWithPath: soundFilePath as String)
        
        //AVAudioPlayerのインスタンス化
        audioPlayer = try! AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint:nil)
        
        //AVAudioPlayerのデリゲートをセット.
        audioPlayer.delegate = self
    }
    
    func scales() {
        
        hanteiLabel.text = "\(musicArray[index])"
        
        let labeltxt : String = hanteiLabel.text!
        switch labeltxt {
        case "C":
            hanteiLabel.text = "ド"
        case "D":
            hanteiLabel.text = "レ"
        case "E":
            hanteiLabel.text = "ミ"
        case "F":
            hanteiLabel.text = "ファ"
        case "G":
            hanteiLabel.text = "ソ"
        case "A":
            hanteiLabel.text = "ラ"
        case "B":
            hanteiLabel.text = "シ"
        default:break
            
        }
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        if loopTimes > 0 {
            setMusic(keyArray[3 - loopTimes])
            loopTimes = loopTimes - 1
            audioPlayer.play()
        }
    }
    
    func Lock() {
        
        print ("kaijonumber\(kaijonumber)")
        
        if kaijonumber == 2 {
            
            firstLabel.text = "ロック解除"
            
        }
        
        if kaijonumber == 1 {
            
            secondLabel.text = "ロック解除"
            
        }
        
        if kaijonumber == 0 {
            thirdLabel.text = "ロック解除"
        }
    }
    
}






