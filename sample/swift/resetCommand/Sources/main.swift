import Foundation

if #available(iOS 15.0, macOS 12.0, *) {
    Task {
        do {
            // Edit code here.
            let roomName = "1000"
            let constants = Constants()
            let animationSettings: [[String: Any]] = [
                ["model": constants.frog1, "position": [0, 0, 0, 0, 0, 0]],
                ["model": constants.frog2, "position": [0, 0, 0, 0, 0, 0]],
                ["model": constants.frog3, "position": [0, 0, 0, 0, 0, 0]],
                ["model": constants.frog4, "position": [0, 5, 0, 0, 0, 0]],
                ["model": constants.frog5, "position": [0, 10, 0, 0, 0, 0]],
                ["model": constants.frog4, "position": [0, 5, 0, 0, 0, 0]],
                ["model": constants.frog3, "position": [0, 0, 0, 0, 0, 0]],
                ["model": constants.frog2, "position": [0, 0, 0, 0, 0, 0]]
            ]
            let vox = VoxelammingSwift(roomName: roomName)

            for _ in 0..<3 {
                for setting in animationSettings {
                    guard let plyFile = setting["model"] as? String,
                          let position = setting["position"] as? [Int] else {
                        continue
                    }

                    for b in getBoxesFromPly(plyFile) {
                        vox.createBox(b.x, b.y, b.z, r: b.r, g: b.g, b: b.b, alpha: b.alpha)
                    }

                    vox.setBoxSize(0.5)
                    vox.setBuildInterval(0)
                    let x = Double(position[0])
                    let y = Double(position[1])
                    let z = Double(position[2])
                    let pitch = Double(position[3])
                    let yaw = Double(position[4])
                    let roll = Double(position[5])
                    vox.transform(x, y, z, pitch: pitch, yaw: yaw , roll: roll)
                    try await vox.sendData()
                    try await vox.sleepSeconds(0.5) // 0.5秒待機

                    vox.clearData()
                    vox.setCommand("reset")
                    try await vox.sendData()
                    try await vox.sleepSeconds(0.5) // 0.5秒待機

                    vox.clearData()
                    try await vox.sleepSeconds(0.5) // 0.5秒待機
                }
            }
            // Edit code here.
        } catch {
            print("An error occurred: \(error)")
        }
    }

    RunLoop.main.run(until: Date(timeIntervalSinceNow: 120)) // Or longer depending on your needs
} else {
    fatalError("This script requires iOS 15.0 / macOS 12.0 or later.")
}
