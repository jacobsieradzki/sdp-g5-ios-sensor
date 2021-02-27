//
//  SensorTestController.swift
//  Vitruvian Sensor
//
//  Created by Jake Sieradzki on 27/02/2021.
//

import UIKit
import CoreMotion

protocol SensorTestControllerDelegate: class {
	func didReceiveAccelerometerReading(reading: Reading)
	func didReceiveGyroscopeReading(reading: Reading)
}

func dateToTimestamp(date: Date) -> String {
	return "\(Int(round(date.timeIntervalSince1970 * 1000)))"
}

struct Reading {
	let time: Date
	let x: Double
	let y: Double
	let z: Double
	
	var timestamp: String {
		return dateToTimestamp(date: time)
	}
}

struct TestRun {
	
	enum ReadingType {
		case accelerometer, gyroscope
	}
	
	let startedAt: Date = Date()
	var accelerometerReadings: [Reading] = []
	var gyroscopeReadings: [Reading] = []
	
	var timestamp: String {
		return dateToTimestamp(date: startedAt)
	}
}

class SensorTestController: NSObject {
	
	// MARK: - Public properties
	public weak var delegate: SensorTestControllerDelegate?
	public var updateInterval: TimeInterval = 0.25
	private(set) var testRun = TestRun()
	
	// MARK: - Private properties
	private let motionManager = CMMotionManager()
	
	// MARK: -
	
	func startTest() {
		testRun = TestRun()
		startAccelerometer()
		startGyroscope()
	}
	
	@discardableResult
	func stopTest() -> TestRun {
		motionManager.stopAccelerometerUpdates()
		motionManager.stopGyroUpdates()
		return testRun
	}
	
	// MARK: - Private
	
	private func startAccelerometer() {
		guard motionManager.isAccelerometerAvailable else {
			return
		}
		
		motionManager.accelerometerUpdateInterval = updateInterval
		motionManager.startAccelerometerUpdates(to: .main, withHandler: didReceiveAccelerometerData)
	}
	
	private func startGyroscope() {
		guard motionManager.isGyroAvailable else {
			return
		}
		
		motionManager.gyroUpdateInterval = updateInterval
		motionManager.startGyroUpdates(to: .main, withHandler: didReceiveGyroscopeData)
	}
	
	// MARK: - Handlers
	
	private func didReceiveAccelerometerData(data: CMAccelerometerData?, error: Error?) {
		guard let data = data else {
			return
		}
		
		let reading = Reading(time: Date(),
							  x: data.acceleration.x,
							  y: data.acceleration.y,
							  z: data.acceleration.z)
		testRun.accelerometerReadings.append(reading)
		delegate?.didReceiveAccelerometerReading(reading: reading)
	}
	
	private func didReceiveGyroscopeData(data: CMGyroData?, error: Error?) {
		guard let data = data else {
			return
		}
		
		let reading = Reading(time: Date(),
							  x: data.rotationRate.x,
							  y: data.rotationRate.y,
							  z: data.rotationRate.z)
		
		testRun.gyroscopeReadings.append(reading)
		delegate?.didReceiveGyroscopeReading(reading: reading)
	}

}
