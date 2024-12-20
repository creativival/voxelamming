import Foundation

if #available(iOS 15.0, macOS 12.0, *) {
    Task {
        do {
            // Edit code here.
            let roomName = "1000"
            let columnNum = 257
            let rowNum = 257
            let constants = Constants()
            let csvFile = constants.map_38_138_100km
            let heightScale = 100.0
            let highColor = (0.5, 0.0, 0.0)
            let lowColor = (0.0, 1.0, 0.0)
            let mapData = getMapDataFromCSV(csvFile: csvFile, heightScale: heightScale)
            let boxes = mapData["boxes"] as! [[Double]] // Assuming the data structure based on given Python code
            let maxHeight = mapData["maxHeight"] as! Double
            // let skip = 1  // high power device
            let skip = 2  // normal
            // let skip = 4  // low power device
            let vox = VoxelammingSwift(roomName: roomName)
            vox.setBoxSize(1)
            vox.setBuildInterval(0.001)
            vox.setCommand("liteRender")

            for j in 0..<(rowNum / skip) {
                for i in 0..<(columnNum / skip) {
                    print(i, j)
                    let x = i - (columnNum / (skip * 2))
                    let z = j - (rowNum / (skip * 2))
                    let y = boxes[j * skip][i * skip]
                    let (r, g, b) = getBoxColor(height: y, maxHeight: maxHeight, highColor: highColor, lowColor: lowColor)

                    if y > 0 {
                        vox.createBox(Double(x), y, Double(z), r: r, g: g, b: b, alpha: 1.0)
                    }
                }
            }

            try await vox.sendData()
            // Edit code here.
        } catch {
            print("An error occurred: \(error)")
        }
    }

    RunLoop.main.run(until: Date(timeIntervalSinceNow: 10)) // Or longer depending on your needs
} else {
    fatalError("This script requires iOS 15.0 / macOS 12.0 or later.")
}
