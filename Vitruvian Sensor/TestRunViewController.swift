//
//  TestRunViewController.swift
//  Vitruvian Sensor
//
//  Created by Jake Sieradzki on 27/02/2021.
//

import UIKit

class TestRunViewController: UIViewController {
	
	// MARK: - Public properties
	public var testRun = TestRun()
	private lazy var csvGenerator = CSVGenerator(testRun: testRun)
	
	// MARK: - Private properties
	@IBOutlet private var tableView: UITableView!
	@IBOutlet private var exportButton: UIButton!
	
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}()
	
	// MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
		exportButton.layer.cornerRadius = 8
    }
	
	@IBAction private func exportPressed() {
		let urls = [csvGenerator.createAccelerometerCSV(), csvGenerator.createGyroscopeCSV()].filter({ $0 != nil })
		let activityViewController = UIActivityViewController(activityItems: urls as [Any], applicationActivities: nil)
		present(activityViewController, animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destination = segue.destination as? ReadingsTableViewController else {
			return
		}
		
		destination.testRun = testRun
		switch segue.identifier {
		case "accelerometer":
			destination.readingType = .accelerometer
		case "gyroscope":
			destination.readingType = .gyroscope
		default: break
		}
	}

}

// MARK: - Table View
extension TestRunViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0: return 1
		case 1: return 2
		default: return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath)
			cell.textLabel?.text = "Test at \(dateFormatter.string(from: testRun.startedAt))"
			return cell
			
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "reading", for: indexPath)
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = "\(testRun.accelerometerReadings.count) accelerometer readings"
				cell.detailTextLabel?.text = csvGenerator.accelerometerFileName
			case 1:
				cell.textLabel?.text = "\(testRun.gyroscopeReadings.count) gyroscope readings"
				cell.detailTextLabel?.text = csvGenerator.accelerometerFileName
			default: break
			}
			return cell
			
		default: fatalError()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.section == 1 else {
			return
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
		switch indexPath.row {
		case 0:
			performSegue(withIdentifier: "accelerometer", sender: self)
		case 1:
			performSegue(withIdentifier: "gyroscope", sender: self)
		default: break
		}
	}
	
}
