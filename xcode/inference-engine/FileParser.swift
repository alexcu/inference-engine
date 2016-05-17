//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A2 - Inference Engine
//  Unit:           COS30019 - Intro to AI
//  Date:           25/04/2016
//

// Only import only funcs and structs we need to use
#if os(Linux)
    // Linux uses Glibc
    import struct Glibc.FILE
    import func   Glibc.fopen
    import func   Glibc.fgets
    import func   Glibc.fclose
#else
    // OS X uses Darwin
    import struct Darwin.C.FILE
    import func   Darwin.C.fopen
    import func   Darwin.C.fgets
    import func   Darwin.C.fclose
#endif

///
/// A simple, cross-platform file parser for reading in files
///
struct FileParser {
    ///
    /// Reads the contents of a file into a string
    /// - Parameter path: The path of the file to open
    /// - Returns: An optional string of the file's contents, or `nil` if the file could
    ///            not be parsed (i.e., it was not readable)
    ///
    static func readFile(path: String) -> String? {
        let filePointer = fopen(path, "r")
        guard filePointer != nil else {
            return nil
        }
        // Read in 256b chunks
        let length = 256
        var result = String()
        let buffer = UnsafeMutablePointer<Int8>.alloc(length)
        while fgets(buffer, Int32(length), filePointer) != nil {
            result += String.fromCString(buffer) ?? ""
        }
        fclose(filePointer)
        return result
    }
}