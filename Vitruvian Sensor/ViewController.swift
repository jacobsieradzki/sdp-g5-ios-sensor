//
//  ViewController.swift
//  Vitruvian Sensor
//
//  Created by Jake Sieradzki on 27/02/2021.
//

import UIKit
import CoreMotion

struct Reading<T> {
	let time: Date
	let value: T
}

class ViewController: UIViewController {
	
	enum State {
		case waitingToStart, recording
	}
	
	// MARK: - Private properties
	private let motionManager = CMMotionManager()
	private var accelerometerTest: [Reading<CMAcceleration>] = []
	private var gyroscopeTest: [Reading<CMRotationRate>] = []
	
	// MARK: - Outlets
	@IBOutlet private var intervalSlider: UISlider!
	@IBOutlet private var intervalValueLabel: UILabel!
	@IBOutlet private var xAccelerometerLabel: UILabel!
	@IBOutlet private var yAccelerometerLabel: UILabel!
	@IBOutlet private var zAccelerometerLabel: UILabel!
	@IBOutlet private var xGyroscopeLabel: UILabel!
	@IBOutlet private var yGyroscopeLabel: UILabel!
	@IBOutlet private var zGyroscopeLabel: UILabel!
	@IBOutlet private var actionButton: UIButton!
	
	// MARK: -

	override func viewDidLoad() {
		super.viewDidLoad()
		setState(.waitingToStart)
		sliderValueDidChange(intervalSlider)
	}
	
	// MARK: - View
	
	func setState(_ state: State) {
		actionButton.layer.cornerRadius = 8
		actionButton.removeTarget(nil, action: nil, for: .allEvents)
		
		switch state {
		case .waitingToStart:
			intervalSlider.isEnabled = true
			actionButton.setTitle("Start recording", for: .normal)
			actionButton.backgroundColor = .link
			actionButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
			actionButton.addTarget(self, action: #selector(startUpdates), for: .touchUpInside)
			
		case .recording:
			intervalSlider.isEnabled = false
			actionButton.setTitle("Stop recording", for: .normal)
			actionButton.backgroundColor = .red
			actionButton.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
			actionButton.addTarget(self, action: #selector(stopUpdates), for: .touchUpInside)
		}
	}
	
	
	// MARK: - Actions
	
	@IBAction private func sliderValueDidChange(_ slider: UISlider) {
		intervalValueLabel.text = "\(slider.value) secs"
	}
	
	@objc private func startUpdates() {
		setState(.recording)
		startAccelerometer()
		startGyroscope()
	}
	
	@objc private func stopUpdates() {
		motionManager.stopAccelerometerUpdates()
		motionManager.stopGyroUpdates()
		setState(.waitingToStart)
		print("Completed test with \(accelerometerTest.count) accelerometer readings and \(gyroscopeTest.count) gyroscope readings")
	}
	
	// MARK: - Cmon
	
	private func startAccelerometer() {
		guard motionManager.isAccelerometerAvailable else {
			return
		}
		
		accelerometerTest = []
		motionManager.accelerometerUpdateInterval = TimeInterval(intervalSlider.value)
		motionManager.startAccelerometerUpdates(to: .main, withHandler: didReceiveAccelerometerData)
	}
	
	private func startGyroscope() {
		guard motionManager.isGyroAvailable else {
			return
		}
		
		gyroscopeTest = []
		motionManager.gyroUpdateInterval = TimeInterval(intervalSlider.value)
		motionManager.startGyroUpdates(to: .main, withHandler: didReceiveGyroscopeData)
	}
	
	// MARK: - Data
	
	private func didReceiveAccelerometerData(data: CMAccelerometerData?, error: Error?) {
		guard let data = data else {
			return
		}
		
		let reading = Reading(time: Date(), value: data.acceleration)
		self.accelerometerTest.append(reading)
		self.xAccelerometerLabel.text = "\(reading.value.x)"
		self.yAccelerometerLabel.text = "\(reading.value.y)"
		self.zAccelerometerLabel.text = "\(reading.value.z)"
	}
	
	private func didReceiveGyroscopeData(data: CMGyroData?, error: Error?) {
		guard let data = data else {
			return
		}
		
		let reading = Reading(time: Date(), value: data.rotationRate)
		self.gyroscopeTest.append(reading)
		self.xGyroscopeLabel.text = "\(reading.value.x)"
		self.yGyroscopeLabel.text = "\(reading.value.y)"
		self.zGyroscopeLabel.text = "\(reading.value.z)"
	}

}
