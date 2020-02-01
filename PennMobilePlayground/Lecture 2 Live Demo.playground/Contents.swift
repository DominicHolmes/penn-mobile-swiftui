import UIKit

struct MosaicCreator {
    
    enum CharacterType {
        case emoji
        case colors
        case number
        case binary
        case alphabet
        
        var example: String {
            switch self {
            case .emoji:
                return "🤖"
            case .alphabet:
                return "a"
            default:
                return "0"
            }
        }
    }
    
    private let characters: Dictionary<CharacterType, String> = [
        .emoji: "🥵😉🥺😪🧚🦞🐢🐧🐔🐸🦊🌎⛄️🍓🍉🥐🍐🥦🥑🍔👾🤖🎃😹👽👻🤯🥳🤠😈😍🤩😄",
        .number: "0123456789",
        .binary: "01",
        .colors: "🟥🟧🟨🟩🟦🟪🟫"
    ]
    
    var defaultCharType: CharacterType? = nil
    
    func create(_ width: Int, by height: Int, with charType: CharacterType) -> String {
        guard width > 0 && height > 0 else { return "🚩 Invalid width or height" }
        guard let chars = characters[charType] else { return "🚩 No characters of that type" }
        
        var output = ""
        
        for _ in 0 ..< height {
            for _ in 0 ..< width {
                output += String(chars.randomElement() ?? Character(" "))
            }
            output += "\n"
        }
        
        return output
    }
    
    func create(_ width: Int, by height: Int) -> String {
        guard let def = defaultCharType else { return "🚩 No default character type specified" }
        return create(width, by: height, with: def)
    }
}

var mosaicCreator = MosaicCreator()
let mosaicCreatorDefaultBinary = MosaicCreator(defaultCharType: .binary)

print(mosaicCreator.create(20, by: 6, with: .binary) + "\n")
print(mosaicCreator.create(0, by: 10, with: .emoji) + "\n")
print(mosaicCreator.create(5, by: 6, with: .alphabet) + "\n")

let chartype = MosaicCreator.CharacterType.emoji


print(mosaicCreatorDefaultBinary.create(5, by: 5))
print(mosaicCreator.create(5, by: 5))

mosaicCreator.defaultCharType = .emoji
print(mosaicCreator.create(5, by: 5))

dump(mosaicCreator)

print(mosaicCreator.create(6, by: 6, with: .colors))
