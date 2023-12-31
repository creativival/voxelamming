import Foundation

if #available(iOS 15.0, macOS 12.0, *) {
    let roomName = "1000"
    let buildBox = BuildBox(roomName: roomName)
    buildBox.setBoxSize(1)
    buildBox.setBuildInterval(0.01)

    Task {
        do {
            let colors: [[Double]] = [
              [0, 0, 0],
              [1, 0, 0],
              [0, 1, 0],
              [0, 0, 1],
              [1, 1, 0],
              [1, 0, 1],
              [0, 1, 1],
              [1, 1, 1],
              [0.5, 0.5, 0.5],
              [0.5, 0, 0],
              [0, 0.5, 0],
              [0, 0, 0.5],
              [0.5, 0.5, 0],
              [0.5, 0, 0.5],
              [0, 0.5, 0.5]
            ]

            for (i, color) in colors.enumerated() {
              buildBox.createBox(0, Double(i), 0, r: color[0], g: color[1], b: color[2], alpha: 1)
            }

            for i in 0..<5 {
                buildBox.changeMaterial(isMetallic: false, roughness: 0.25 * Double(i))
                buildBox.translate(Double(i), 0, 0, pitch: 0, yaw: 0, roll: 0)
                try await buildBox.sendData()
                sleep(1)
            }

            for i in 0..<5 {
                buildBox.changeMaterial(isMetallic: true, roughness: 0.25 * Double(i))
                buildBox.translate(Double(5 + i), 0, 0, pitch: 0, yaw: 0, roll: 0)
                try await buildBox.sendData()
                sleep(1)
            }
        } catch {
            print("An error occurred: \(error)")
        }
    }

    RunLoop.main.run(until: Date(timeIntervalSinceNow: 10)) // Or longer depending on your needs
} else {
    fatalError("This script requires iOS 15.0 / macOS 12.0 or later.")
}
