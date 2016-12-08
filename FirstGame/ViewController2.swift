//
//  ViewController.swift
//  FirstGame
//
//  Created by Brandmind on 02.12.16.
//  Copyright © 2016 Brandmind. All rights reserved.
//

import UIKit
import AVFoundation

var runner1p = 0
var runner2p = 0

var runner1win: Bool = false
var runner2win: Bool = false

class ViewController2: UIViewController {
    var go_sound = AVAudioPlayer()
    var go_sound2 = AVAudioPlayer()
    
    let runner1i: UIImage = UIImage(named: "runner1.png")!
    let runner1v: UIImageView = UIImageView()
    
    let runner2i: UIImage = UIImage(named: "runner2.png")!
    let runner2v: UIImageView = UIImageView()
    
    var x: [Int] =
    [
        5,45,85,125,165,205,245,285,
        285,245,205,165,125,85,45,5,
        5,45,85,125,165,205,245,285,
        285,245,205,165,125,85,45,5,
        5,45,85,125,165,205,245,285,
        285,245,205,165,125,85,45,5,
        5,45,85,125,165,205,245,285,
        285,245,205,165,125,85,45,5
    ]
    
    var y: [Int] =
    [
        305,305,305,305,305,305,305,305,
        265,265,265,265,265,265,265,265,
        225,225,225,225,225,225,225,225,
        185,185,185,185,185,185,185,185,
        145,145,145,145,145,145,145,145,
        105,105,105,105,105,105,105,105,
        65,65,65,65,65,65,65,65,
        25,25,25,25,25,25,25,25
        
    ]
    
    @IBOutlet weak var runner1text: UILabel!
    @IBOutlet weak var runner2text: UILabel!
    
    @IBOutlet weak var go: UIButton!
    
    @IBOutlet weak var cube_img: UIImageView!
    
    
    
    func runner1_view() {
        runner1v.image = runner1i
        runner1v.frame.size.width = 30
        runner1v.frame.size.height = 30
        UIView.animate(withDuration: 0.8, animations: {
            self.runner1v.frame.origin.x = CGFloat(self.x[runner1p])
            self.runner1v.frame.origin.y = CGFloat(self.y[runner1p])
            
        })
        view.addSubview(runner1v)
    }
    
    func runner2_view() {
        runner2v.image = runner2i
        runner2v.frame.size.width = 30
        runner2v.frame.size.height = 30
        UIView.animate(withDuration: 0.8, animations: {
            self.runner2v.frame.origin.x = CGFloat(self.x[runner2p])
            self.runner2v.frame.origin.y = CGFloat(self.y[runner2p])
            
        })
        view.addSubview(runner2v)
    }
    
    func cube_go() -> Int {
        let c = Int(arc4random_uniform(6)+1)
        let cube_num:String = "cube" + String(c) + ".png"
        let ci : UIImage = UIImage(named: cube_num)!
        cube_img.image = ci
        view.addSubview(cube_img)
        return c
    }
    
    func runner2go() {
        runner2p += cube_go()
        var sound = URL(fileURLWithPath: Bundle.main.path(forResource: "runner2s2", ofType: "mp3")!)
        
        do {
            go_sound = try AVAudioPlayer(contentsOf: sound)
            go_sound.prepareToPlay()
            go_sound.play()
        }
        catch {
            print("Ошибка!")
        }
        
        go.isEnabled = true
        go.backgroundColor = UIColor.green
        go.setTitle("Вперед!", for: .normal)
        
        if (runner2p < 63) {
            runner2_view()
        }
        else {
            if (runner2win != true) {
                runner2p = 63
                runner2_view()
                runner2win = true
                
                let alert = UIAlertController(title: "Соперник победил!", message: "Повезет в другой раз!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Еще раз!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {

                runner2p = 0
                runner2_view()
                runner1p = 0
                runner1_view()
                runner2win = false
                runner1text.text = "Ваша позиция: \(runner1p)"
                
            }
        }
        runner2text.text = "Соперника: \(runner2p)"
    }
    
    @IBAction func go(_ sender: UIButton) {
        runner1p += cube_go()
        var sound = URL(fileURLWithPath: Bundle.main.path(forResource: "runner1s2", ofType: "mp3")!)
        
        do {
            go_sound = try AVAudioPlayer(contentsOf: sound)
                go_sound.prepareToPlay()
                go_sound.play()
        }
        catch {
            print("Ошибка!")
        }
      
        if (runner1p < 63) {
            if (runner2p != 63) {
                runner1_view()
                
                go.isEnabled = false
                go.backgroundColor = UIColor.red
                go.setTitle("Ожидаем соперника", for: .normal)
                
                _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController2.runner2go),userInfo: nil, repeats: false)
            }
            else {
                // Обработка победы Соперника
                runner1p = 0
                runner1_view()
                runner2p = 0
                runner2_view()
                runner1win = false
                runner2text.text = "Соперника: \(runner2p)"
                runner2win = false
                
            }
        }
        else {
            if (runner1win != true) {
                runner1p = 63
                runner1_view()
                runner1win = true
                
                let alert = UIAlertController(title: "Вы победили!", message: "Поздравляем", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ура!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                // Обработка победы Игрока
                
                runner1p = 0
                runner1_view()
                runner2p = 0
                runner2_view()
                runner1win = false
                runner2text.text = "Соперника: \(runner2p)"
                
            }
        }
        runner1text.text = "Ваша позиция: \(runner1p)"
        
      
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runner1_view()
        runner2_view()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

