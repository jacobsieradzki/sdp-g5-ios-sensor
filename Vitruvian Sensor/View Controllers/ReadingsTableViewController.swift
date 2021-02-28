//
//  ReadingsTableViewController.swift
//  Vitruvian Sensor
//
//  Created by Jake Sieradzki on 27/02/2021.
//

import UIKit

class ReadingsTableViewController: UITableViewController {
	
	public var testRun = TestRun()
	public var readingType: TestRun.ReadingType = .accelerometer

	override func viewDidLoad() {
		super.viewDidLoad()
		
		switch readingType {
		case .accelerometer:
			title = "Accelerometer"
		case .gyroscope:
			title = "Gyroscope"
		}
	}
}

// MARK: - Table View
extension ReadingsTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch readingType {
		case .accelerometer:
			return testRun.accelerometerReadings.count
		case .gyroscope:
			return testRun.gyroscopeReadings.count
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reading", for: indexPath)

		let reading: Reading = {
			switch readingType {
			case .accelerometer:
				return testRun.accelerometerReadings[indexPath.row]
			case .gyroscope:
				return testRun.gyroscopeReadings[indexPath.row]
			}
		}()
		
		cell.textLabel?.text = """
			t = \(reading.timestamp)
			x = \(reading.x)
			y = \(reading.y)
			z = \(reading.z)
			"""

        return cell
    }

}
