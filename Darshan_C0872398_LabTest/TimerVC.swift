//
//  TimerVC.swift
//  Darshan_C0872398_LabTest
//
//  Created by Darshan Jain on 2022-11-04.
//

import UIKit

class TimerVC: UIViewController {

	@IBOutlet weak var datePicker: UIDatePicker!
	
	@IBOutlet weak var progressView: UIProgressView!
	
	@IBOutlet weak var cancelView: UIView!
	@IBOutlet weak var startView: UIView!
	
	@IBOutlet weak var startLabel: UILabel!
	private var countdown: Float = 60.0
	private var timer: Timer?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		progressView.isHidden = true
		
		cancelView.layer.cornerRadius = cancelView.frame.width / 2
		
		let cancelTap = UITapGestureRecognizer(target: self, action: #selector(onCancePress))
		cancelView.addGestureRecognizer(cancelTap)
		
		startView.layer.cornerRadius = startView.frame.width / 2
		let startTap = UITapGestureRecognizer(target: self, action: #selector(onStartPress))
		startView.addGestureRecognizer(startTap)
		
    }
	
	@objc func onCancePress(_ skip: Bool = false) {
		datePicker.isUserInteractionEnabled = true
		startLabel.text = "Start"
		timer?.invalidate()
		
		if !skip {
			countdown = 60
			progressView.setProgress(1, animated: true)
			progressView.isHidden = true
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

}

