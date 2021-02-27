//
//  ViewController.swift
//  Vitruvian Sensor
//
//  Created by Jake Sieradzki on 27/02/2021.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
	
	enum State {
		case waitingToStart, recording
	}
	
	// MARK: - Private
	private let sensorTestController = SensorTestController()
	
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
		sensorTestController.delegate = self
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
		sensorTestController.updateInterval = TimeInterval(slider.value)
		intervalValueLabel.text = "\(slider.value) secs"
	}
	
	@objc private func startUpdates() {
		setState(.recording)
		sensorTestController.startTest()
	}
	
	@objc private func stopUpdates() {
		let testRun = sensorTestController.stopTest()
		setState(.waitingToStart)
		
		print("Completed with \(testRun.accelerometerReadings.count) --- \(testRun.gyroscopeReadings.count)")
	}
	
}

extension ViewController: SensorTestControllerDelegate {
	
	func didReceiveAccelerometerReading(reading: Reading) {
		self.xAccelerometerLabel.text = "\(reading.x)"
		self.yAccelerometerLabel.text = "\(reading.y)"
		self.zAccelerometerLabel.text = "\(reading.z)"
	}
	
	func didReceiveGyroscopeReading(reading: Reading) {
		self.xGyroscopeLabel.text = "\(reading.x)"
		self.yGyroscopeLabel.text = "\(reading.y)"
		self.zGyroscopeLabel.text = "\(reading.z)"
	}
	
}
