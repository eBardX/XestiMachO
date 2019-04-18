// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

internal extension FileHandle {

    // MARK: Public Instance Methods

    func read(from offset: UInt64,
              for count: Int) -> Data? {
        seek(toFileOffset: offset)

        let data = readData(ofLength: count)

        return data.count >= count ? data : nil
    }

    func readMagic(at offset: UInt64) -> Magic? {
        guard
            let data = read(from: offset,
                            for: MemoryLayout<UInt32>.size),
            let rawMagic: UInt32 = data.extract()
            else { return nil }

        return Magic(rawValue: rawMagic)
    }
}
