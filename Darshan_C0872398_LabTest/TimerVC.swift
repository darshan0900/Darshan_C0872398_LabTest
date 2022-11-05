//
//  TimerVC.swift
//  Darshan_C0872398_LabTest
//
//  Created by Darshan Jain on 2022-11-04.
//

import UIKit
import AVFoundation

class TimerVC: UIViewController {

	@IBOutlet weak var datePicker: UIDatePicker!
	
	@IBOutlet weak var progressView: UIProgressView!
	
	@IBOutlet weak var cancelView: UIView!
	@IBOutlet weak var startView: UIView!
	
	@IBOutlet weak var startLabel: UILabel!
	private var countdown: Float = 60.0
	private var timer: Timer?
	private var player: AVAudioPlayer?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		progressView.isHidden = true
		
		cancelView.layer.cornerRadius = cancelView.frame.width / 2
		
		let cancelTap = UITapGestureRecognizer(target: self, action: #selector(onCancePress))
		cancelView.addGestureRecognizer(cancelTap)
		
		startView.layer.cornerRadius = startView.frame.width / 2
		let startTap = UITapGestureRecognizer(target: self, action: #selector(onStartPress))
		startView.addGestureRecognizer(startTap)
		
		prepareSound()
		
    }
	
	@objc func onCancePress(_ skip: Bool = false, _ end: Bool = false) {
		datePicker.isUserInteractionEnabled = true
		startLabel.text = "Start"
		timer?.invalidate()
		
		if !skip {
			datePicker.countDownDuration = 0
			countdown = 60
			progressView.setProgress(1, animated: true)
			progressView.isHidden = true
		}
		if end {
			playSound()
		} else {
			stopSound()
		}
		
	}
	
	@objc func onStartPress() {
		if startLabel.text == "Start" {
			datePicker.isUserInteractionEnabled = false
			startLabel.text = "Pause"
			progressView.isHidden = false
			if countdown == 60 {
				countdown = Float(datePicker.countDownDuration)
				progressView.setProgress(1, animated: true)
			}
			timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true ){timer in
				self.countdown -= 1
				if self.countdown == 0 {
					self.onCancePress(false, true)
					return
				}
				let seconds = Float(self.countdown.truncatingRemainder(dividingBy: 60))
				UIView.animate(withDuration: 0.5, animations: {
					print(seconds)
					if seconds < 10.0 {
						self.progressView.progressTintColor = .systemRed
					} else if seconds < 30.0 {
						self.progressView.progressTintColor = .systemYellow
					} else {
						self.progressView.progressTintColor = .systemBlue
					}
					self.progressView.setProgress(seconds / 60, animated: true)
					if seconds == 0 {
						self.datePicker.countDownDuration -= 60.0
						self.progressView.setProgress(1, animated: true)
						self.progressView.progressTintColor = .systemBlue
					}
				})
			}
		} else {
			onCancePress(true)
		}
			
	}
	
	func prepareSound() {
		let url = Bundle.main.url(forResource: "IphoneAlarm", withExtension: "mp3")!
		do {
			try? AVAudioSession.sharedInstance().setCategory(.playback)
			player = try AVAudioPlayer(contentsOf: url)
		} catch let error {
			print(error)
		}
	}

	func playSound(){
		player?.play()
	}
	
	func stopSound(){
		player?.pause()
		player?.currentTime = 0
	}
	
	
}

