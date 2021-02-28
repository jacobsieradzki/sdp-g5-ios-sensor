//
//  CSVGenerator.swift
//  Vitruvian Sensor
//
//  Created by Jake Sieradzki on 27/02/2021.
//

import UIKit

class CSVGenerator: NSObject {
	
	// MARK: - Public properties
	var accelerometerFileName: String {
		return "accelerometer-\(testRun.timestamp).csv"
	}
	
	var gyroscopeFileName: String {
		return "gyroscope-\(testRun.timestamp).csv"
	}
	
	// MARK: - Private properties
	private let testRun: TestRun
	private let fileManager = FileManager.default
	
	// MARK: -
	
	init(testRun: TestRun) {
		self.testRun = testRun
	}
	
	func createAccelerometerCSV() -> URL? {
		return createCSV(readings: testRun.accelerometerReadings, fileName: accelerometerFileName)
	}
	
	func createGyroscopeCSV() -> URL? {
		return createCSV(readings: testRun.gyroscopeReadings, fileName: gyroscopeFileName)
	}
	
	// MARK: - Private
		
	private func createCSV(readings: [Reading], fileName: String) -> URL? {
		var output = "timestamp,x,y,z\n"
		
		for reading in readings {
			output += "\(reading.time.timeIntervalSince1970),\(reading.x),\(reading.y),\(reading.z)\n"
		}
		
		do {
			guard let documentPath = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first else {
				return nil
			}
			
			let fileUrl = documentPath.appendingPathComponent(fileName)
			try output.write(to: fileUrl, atomically: true, encoding: .utf8)
			return fileUrl
		} catch {
			print("Error generating CSV", error)
			return nil
		}
	}

}
