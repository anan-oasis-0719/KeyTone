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
    let keytoneArray:[String] = []
    var keytoneindex: Int! // viewDidLoadで設定する
    
    var keytonenumber: Int = 3
    var zankitonenumber: Int = 0
    var zankinumber: Int = 3
    
    var keytoneLevel: Int = 3 //３連の正解音
    var keyArray:[Int] = [] //３連の正解音を格納する配列
    var loopTimes: Int! = 0 // 残りのループ回数
    
    var selectArray: [Int] = [] // 選択した音の配列
    var selectindex: Int! //その要素数??
    
    @IBOutlet var hanteiLabel: UILabel!
    @IBOutlet var keytoneLabel: UILabel!
    @IBOutlet var zankiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //kyetoneindex = Int(arc4random_uniform(UInt32(7)))
        
        // 正解音の決定
        //        keytoneindex = Int(arc4random_uniform(UInt32(7)))
        keyArray = [] //　初期化
        for i in 0 ..< keytoneLevel { //３なら３回ループ
            keyArray.append(Int(arc4random_uniform(UInt32(7))))
            print(keyArray[i])
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
        
//        do {
            audioPlayer = try! AVAudioPlayer(contentsOfURL: music)
//        } catch {
//            // couldn't load file :(
//        }
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
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: music)
        } catch {
            // couldn't load file :(
        }
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
        
        // 正誤判定
        
        let lastTime: Int = keytoneLevel-1
        for i in 0 ..< selectArray.count {
            if selectArray[i] != keyArray[i] {
                hanteiLabel.text = "違います！"
                selectArray = [] // 初期化
                zankinumber = zankinumber-1
                
                if zankinumber <= 0 {
                    
                    performSegueWithIdentifier("a",sender: nil)
                    
                }
                
                if zankinumber  == 1 {
                    
                    zankiLabel.textColor = UIColor.redColor()
                    
                }
                    
                else if zankinumber  == 2 {
                    
                    zankiLabel.textColor = UIColor.orangeColor()
                    
                }
                
                zankiLabel.text = "残機×\(zankinumber)"
                break
            } else {
                hanteiLabel.text = "次の音を選んで「決定」せよ"
            }
            
            
            if i == lastTime {
                if selectArray[lastTime] == keyArray[lastTime] {
                    // 正解画面に遷移
                    performSegueWithIdentifier("b",sender: nil)
                }
            }
        }
        
        
        
    }
    
    func setMusic(index: Int){
        //再生する音源のURLを生成.
        let soundFilePath : NSString = NSBundle.mainBundle().pathForResource(musicArray[index],ofType:
            "mp3")!
        let fileURL : NSURL = NSURL(fileURLWithPath: soundFilePath as String)
        
        //AVAudioPlayerのインスタンス化
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint:nil)
        }catch{
            print("失敗：Failed AVAudioPlayer Instance")
        }
        
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
    
}






