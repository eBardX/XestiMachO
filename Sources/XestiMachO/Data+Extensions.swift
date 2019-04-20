// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public extension Data {

    // MARK: Public Instance Methods

    func extract<T>() -> T? {
        guard
            count >= MemoryLayout<T>.size
            else { return nil }

        let instance: T? = withUnsafeBytes {
            $0.baseAddress?.assumingMemoryBound(to: T.self).pointee
        }

        return instance
    }

    func extractDylibCommand(_ isSwapped: Bool) -> dylib_command? {
        guard
            var command: dylib_command = extract()
            else { return nil }

        if isSwapped {
            swap_dylib_command(&command, NX_UnknownByteOrder)
        }

        return command
    }

    func extractFatArch(_ isSwapped: Bool) -> fat_arch? {
        guard
            var arch: fat_arch = extract()
            else { return nil }

        if isSwapped {
            swap_fat_arch(&arch, 1, NX_UnknownByteOrder)
        }

        return arch
    }

    func extractFatArch64(_ isSwapped: Bool) -> fat_arch_64? {
        guard
            var arch: fat_arch_64 = extract()
            else { return nil }

        if isSwapped {
            swap_fat_arch_64(&arch, 1, NX_UnknownByteOrder)
        }

        return arch
    }

    func extractFatHeader(_ isSwapped: Bool) -> fat_header? {
        guard
            var header: fat_header = extract()
            else { return nil }

        if isSwapped {
            swap_fat_header(&header, NX_UnknownByteOrder)
        }

        return header
    }

    func extractLinkeditDataCommand(_ isSwapped: Bool) -> linkedit_data_command? {
        guard
            var command: linkedit_data_command = extract()
            else { return nil }

        if isSwapped {
            swap_linkedit_data_command(&command, NX_UnknownByteOrder)
        }

        return command
    }

    func extractLoadCommand(_ isSwapped: Bool) -> load_command? {
        guard
            var command: load_command = extract()
            else { return nil }

        if isSwapped {
            swap_load_command(&command, NX_UnknownByteOrder)
        }

        return command
    }

    func extractMachHeader(_ isSwapped: Bool) -> mach_header? {
        guard
            var header: mach_header = extract()
            else { return nil }

        if isSwapped {
            swap_mach_header(&header, NX_UnknownByteOrder)
        }

        return header
    }

    func extractMachHeader64(_ isSwapped: Bool) -> mach_header_64? {
        guard
            var header: mach_header_64 = extract()
            else { return nil }

        if isSwapped {
            swap_mach_header_64(&header, NX_UnknownByteOrder)
        }

        return header
    }

    func extractMagic() -> Magic? {
        guard
            let rawMagic: UInt32 = extract()
            else { return nil }

        return Magic(rawValue: rawMagic)
    }

    func extractSegmentCommand(_ isSwapped: Bool) -> segment_command? {
        guard
            var command: segment_command = extract()
            else { return nil }

        if isSwapped {
            swap_segment_command(&command, NX_UnknownByteOrder)
        }

        return command
    }

    func extractSegmentCommand64(_ isSwapped: Bool) -> segment_command_64? {
        guard
            var command: segment_command_64 = extract()
            else { return nil }

        if isSwapped {
            swap_segment_command_64(&command, NX_UnknownByteOrder)
        }

        return command
    }
}
