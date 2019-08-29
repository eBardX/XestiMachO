// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

private let bufferSize = UInt32(8192)

public extension FileHandle {

    // MARK: Public Instance Methods

    func copy(_ srcFileHandle: FileHandle,
              from srcOffset: UInt64,
              to dstOffset: UInt64,
              for size: UInt32) throws {
        srcFileHandle.seek(toFileOffset: srcOffset)

        seek(toFileOffset: dstOffset)

        var bytesLeft = size

        while bytesLeft > 0 {
            let tmpSize = min(bytesLeft, bufferSize)
            let data = srcFileHandle.readData(ofLength: Int(tmpSize))

            write(data)

            bytesLeft -= UInt32(data.count)
        }

        truncateFile(atOffset: dstOffset + UInt64(size))
    }

    func writeFatArchs(_ archs: [FatArch]) throws {
        for arch in archs {
            try _writeData(arch.rawData,
                           to: arch.offset,
                           for: arch.size)
        }
    }

    func writeFatHeader(_ header: FatHeader) throws {
        try _writeData(header.rawData,
                       to: header.offset,
                       for: header.size)
    }

    func writeLoadCommands(_ commands: [LoadCommand]) throws {
        for command in commands {
            try _writeData(command.rawData,
                           to: command.offset,
                           for: command.size)
        }
    }

    func writeMachHeader(_ header: MachHeader) throws {
        try _writeData(header.rawData,
                       to: header.offset,
                       for: header.size)
    }

    // MARK: Private Instance Methods

    private func _writeData(_ data: Data,
                            to offset: UInt64,
                            for size: UInt32) throws {
        seek(toFileOffset: offset)

        write(data)

        truncateFile(atOffset: offset + UInt64(size))
    }
}
