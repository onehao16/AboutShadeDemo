//
//  ViewController.swift
//  摇一摇
//
//  Created by 黄蒿云 on 16/7/26.
//  Copyright © 2016年 huanghaoyun. All rights reserved.
//

import UIKit
import AVFoundation

let screenW = UIScreen.mainScreen().bounds.width
let screenH = UIScreen.mainScreen().bounds.height
class ViewController: UIViewController,AVAudioPlayerDelegate {

    var imagebg : UIImageView!
    var upimage : UIImageView!
    var downImage : UIImageView!
    var playerMp3 : AVAudioPlayer?
    var sound : SystemSoundID!
    lazy var datailbtn : UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.titleLabel!.font = UIFont.systemFontOfSize(14)
        btn.titleLabel!.textColor = UIColor.redColor()
        btn.titleLabel!.numberOfLines = 0
        btn.backgroundColor = UIColor.brownColor()
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // 设置允许摇一摇功能
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true
        // 并让自己成为第一响应者
        self.becomeFirstResponder()
        
        //添加背景
        imagebg = UIImageView()
        imagebg.image = UIImage(named: "1.jpg")
        imagebg.backgroundColor = UIColor.blackColor()
        imagebg.frame = view.frame
        view.addSubview(imagebg)

        //上面的ImageView
        upimage = UIImageView(image: UIImage(named: "Shake_Logo_Up_150x83_"))
        upimage.bounds = CGRectMake(0, 0,  screenW/2,  screenH/4)
        upimage.center = CGPointMake(view.center.x, view.center.y - screenH/8)
        view.addSubview(upimage)
        
        //下面的imageView
        downImage = UIImageView(image: UIImage(named: "Shake_Logo_Down_150x82_"))
        downImage.bounds = CGRectMake(0, 0, screenW/2, view.bounds.height/4)
        downImage.center = CGPointMake(view.center.x, view.center.y + screenH/8)
        view.addSubview(downImage)
        
        view.addSubview(datailbtn)


    }


    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("开始摇一摇")
        
        
        UIView.animateWithDuration(0.5, animations: {
            self.upimage.frame.origin.y -= 100
            self.downImage.frame.origin.y += 100
            }) { (_) in
        }
        //播放声音
        let urlmp3 = NSBundle.mainBundle().URLForResource("rock.mp3", withExtension: nil)!

        //强制try
        do{
            try playerMp3 = AVAudioPlayer(contentsOfURL: urlmp3)
        }catch{
            print("有异常")
        }
        self.playerMp3?.prepareToPlay()
        self.playerMp3?.play()
        //结束动画
        let offset = CGFloat(100.0)
        UIView.animateKeyframesWithDuration(0.5, delay: 1, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: {
                self.upimage.frame.origin.y += offset
                self.downImage.frame.origin.y -= offset
            }) { (_) in
        }

       
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("摇一摇结束")
        //摇一摇成功 在这里做你想做的事情吧
        
        setData()
        //振动效果
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        //如果有摇动动作，就做相应操作
        if event?.subtype == UIEventSubtype.MotionShake {
            self.view.backgroundColor = UIColor(red: (CGFloat(arc4random())%255.0)/255.0, green: (CGFloat(arc4random())%255.0)/255.0, blue: (CGFloat(arc4random())%255.0)/255.0, alpha: 1)
        }
        //播放声音
        let urlmp3 = NSBundle.mainBundle().URLForResource("rock_end.mp3", withExtension: nil)!
        //强制try
        do{
            try playerMp3 = AVAudioPlayer(contentsOfURL: urlmp3)
        }catch{
            print("有异常")
        }
        self.playerMp3?.prepareToPlay()
        self.playerMp3?.play()
    }
    
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("取消摇一摇")
    }
    
    func setData() {
        
        let title = "你想要什么样子的美女"
        datailbtn.setTitle(title, forState: UIControlState.Normal)
        
        let size = title.boundingRectWithSize(CGSizeMake(280, 0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14.0)], context: nil)
        datailbtn.frame = CGRectMake(screenW/2-140, screenH - size.height - 64, 280, size.height)
    }
}