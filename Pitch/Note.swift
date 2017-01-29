/*
 * Copyright (c) 2016 Tim van Elsloo
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import Foundation

/**
 * A key is essentially just a note, so we can use one class for Key and Note types.
 */
typealias Key = Note

enum Note: Int, CustomStringConvertible {
    case fsharp
    case g
    case gsharp
    case a
    case asharp
    case b
    case c
    case csharp
    case d
    case dsharp
    case e
    case f

    /**
     * This array contains all notes.
     */
    static let all: [Note] = [.c, .csharp, .d, .dsharp, .e, .f, .fsharp, .g, .gsharp, .a, .asharp, .b]
    
    /**
     * Initializes a new Note from a given name.
     */
    static func fromName(_ name: String) -> Note? {
        return all.filter { note in
            return name == note.sharpName || name == note.flatName
        }.first
    }
    
    /**
     * How far a particular note or key is from C.
     */
    var concertOffset: Int {
        return self.rawValue - 6
    }
    
    /**
     * concertOffset formatted as a string (i.e "+2" or "-5")
     */
    var concertOffsetString: String {
        return concertOffset < 0 ? "\(concertOffset)" : "+\(concertOffset)"
    }

    /**
     * This function returns the frequency of this note in the 4th octave.
     */
    var frequency: Double {
        let index = Note.all.index(where: { $0 == self })! -
                    Note.all.index(where: { $0 == Note.a })!
        let pitchStandard = UserDefaults.standard.pitchStandard()
        
        return pitchStandard * pow(2, Double(index) / 12.0)
    }

    /**
     * This property is used in the User Interface to show the name of this
     * note.
     */
    var description: String {
        let displayMode = UserDefaults.standard.displayMode()
        switch displayMode {
        case .sharps:
            return sharpName
        case .flats:
            return flatName
        }
    }
    
    fileprivate var sharpName: String {
        switch self {
        case .a:
            return "A"
        case .asharp:
            return "A♯"
        case .b:
            return "B"
        case .c:
            return "C"
        case .csharp:
            return "C♯"
        case .d:
            return "D"
        case .dsharp:
            return "D♯"
        case .e:
            return "E"
        case .f:
            return "F"
        case .fsharp:
            return "F♯"
        case .g:
            return "G"
        case .gsharp:
            return "G♯"
        }
    }

    fileprivate var flatName: String {
        switch self {
        case .a, .b, .c, .d, .e, .f, .g:
            return sharpName
        case .asharp:
            return "B♭"
        case .csharp:
            return "D♭"
        case .dsharp:
            return "E♭"
        case .fsharp:
            return "G♭"
        case .gsharp:
            return "A♭"
        }
    }
}

/**
 * We override the equality operator so we can use `indexOf` on the static array
 * of all notes. Using the `description` property isn't the most idiomatic way
 * to do this but it does the job.
 */
func ==(a: Note, b: Note) -> Bool {
    return a.sharpName == b.sharpName
}
