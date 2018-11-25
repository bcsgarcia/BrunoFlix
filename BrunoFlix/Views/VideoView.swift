//
//  VideoView.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 24/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import UIKit
import AVKit
import Cartography

class VideoView: NSObject {
    
    let blackView = UIView()
   
    var isPlaying = false
    
    let videoView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    var player: AVPlayer!
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    override init(){
        super.init()
    }
    
    func showVideo(with title: String){
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlerDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(videoView)
            
            constrain(blackView, window) { view, superview in
                view.top == superview.safeAreaLayoutGuide.top
                view.left == superview.left
                view.right == superview.right
                view.bottom == superview.bottom
            }
            
            constrain(videoView, blackView) { view, superview in
                
                view.center == view.superview!.center
                view.left == superview.safeAreaLayoutGuide.left
                view.right == superview.safeAreaLayoutGuide.right
                view.height == 300
            }
            
            blackView.alpha = 0
            videoView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.videoView.alpha = 1
                
            }) { (isOk) in
                if self.player == nil {
                    self.configVideoView(for: title)
                }
                else {
                    self.playPause()
                }
            }
        }
    }
    
    @objc func handlerDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.videoView.alpha = 0
        }
        
        player?.pause()
        isPlaying = false
    }
    
    @objc func playPause(){
        
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    func play() {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback,
                                         mode: .spokenAudio,
                                         options: .duckOthers)
            
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            player?.play()
            isPlaying = true
        } catch let error as NSError {
            print("LOG: audioSession error: \(error.localizedDescription)")
        }
    }
    
    fileprivate func configVideoView(for title: String) {
        
        Rest.load(movieName: title) { (url, error) in
            if error != nil {
                print(error!)
                return
            } else {
                guard let url = url else {
                    return
                }
                //print(url)
                self.player = AVPlayer(url: url)
                let layerPlayer = AVPlayerLayer(player: self.player)
                layerPlayer.frame = self.videoView.bounds
                layerPlayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.videoView.layer.addSublayer(layerPlayer)
                self.play()
            }
        }
    }
    
}
