import SwiftUI

// MARK: - Stance state

/// The body's relationship to the ground — the "state" of a yoga stance.
enum Stance: String, CaseIterable, Identifiable, Codable {
    case standing  = "Standing"
    case seated    = "Seated"
    case supine    = "Supine"      // lying face-up
    case prone     = "Prone"       // lying face-down
    case kneeling  = "Kneeling"
    case balancing = "Balancing"
    case inversion = "Inversion"
    case restorative = "Restorative"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .standing:    return "figure.stand"
        case .seated:      return "figure.seated.side"
        case .supine:      return "figure.flexibility"
        case .prone:       return "figure.core.training"
        case .kneeling:    return "figure.barre"
        case .balancing:   return "figure.yoga"
        case .inversion:   return "figure.gymnastics"
        case .restorative: return "figure.mind.and.body"
        }
    }

    var tint: Color {
        switch self {
        case .standing:    return Theme.sage
        case .seated:      return Theme.clay
        case .supine:      return Theme.sky
        case .prone:       return Theme.coral
        case .kneeling:    return Theme.amber
        case .balancing:   return Theme.primary
        case .inversion:   return Theme.plum
        case .restorative: return Theme.teal
        }
    }
}

enum Difficulty: String, CaseIterable, Identifiable, Codable {
    case beginner     = "Beginner"
    case intermediate = "Intermediate"
    case advanced     = "Advanced"

    var id: String { rawValue }

    var pips: Int {
        switch self {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        }
    }

    var color: Color {
        switch self {
        case .beginner:     return Theme.sage
        case .intermediate: return Theme.amber
        case .advanced:     return Theme.coral
        }
    }
}

// MARK: - Pose

struct Pose: Identifiable, Hashable, Codable {
    let id: String
    let name: String          // common English name
    let sanskrit: String      // Sanskrit name
    let symbol: String        // SF Symbol used as the icon / animated figure
    let stance: Stance
    let difficulty: Difficulty
    let focus: String         // one-line focus
    let benefits: [String]
    let steps: [String]
    let defaultHold: Int      // seconds typically held

    static func == (lhs: Pose, rhs: Pose) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Sequence

struct SequenceStep: Identifiable, Hashable, Codable {
    var id: String { poseID }
    let poseID: String
    let seconds: Int          // hold time for this step in this sequence

    var pose: Pose { YogaLibrary.pose(poseID) }
}

struct YogaSequence: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let subtitle: String
    let symbol: String
    let level: Difficulty
    let steps: [SequenceStep]

    var totalSeconds: Int { steps.reduce(0) { $0 + $1.seconds } }
    var minutes: Int { Int((Double(totalSeconds) / 60.0).rounded()) }
}

// MARK: - Library

enum YogaLibrary {

    static func pose(_ id: String) -> Pose {
        poses.first { $0.id == id } ?? poses[0]
    }

    static func poses(in stance: Stance) -> [Pose] {
        poses.filter { $0.stance == stance }
    }

    // MARK: Poses

    static let poses: [Pose] = [
        Pose(id: "mountain", name: "Mountain Pose", sanskrit: "Tadasana",
             symbol: "figure.stand", stance: .standing, difficulty: .beginner,
             focus: "Grounding & posture",
             benefits: ["Improves posture", "Builds body awareness", "Strengthens thighs & ankles"],
             steps: ["Stand with feet hip-width, weight even across both feet.",
                     "Engage thighs, lengthen the spine, relax the shoulders down.",
                     "Arms by your sides, palms forward. Breathe steady and tall."],
             defaultHold: 30),

        Pose(id: "forward_fold", name: "Standing Forward Fold", sanskrit: "Uttanasana",
             symbol: "figure.flexibility", stance: .standing, difficulty: .beginner,
             focus: "Hamstring release",
             benefits: ["Stretches hamstrings & calves", "Calms the mind", "Relieves lower-back tension"],
             steps: ["From Mountain, hinge at the hips and fold forward.",
                     "Let the head hang heavy; soften the knees if needed.",
                     "Hold opposite elbows or rest hands on the floor."],
             defaultHold: 30),

        Pose(id: "chair", name: "Chair Pose", sanskrit: "Utkatasana",
             symbol: "figure.cooldown", stance: .standing, difficulty: .intermediate,
             focus: "Leg & core strength",
             benefits: ["Strengthens quads & glutes", "Tones the core", "Builds heat"],
             steps: ["Feet together, bend the knees and sink the hips back.",
                     "Reach arms overhead alongside the ears.",
                     "Keep weight in the heels, chest lifted."],
             defaultHold: 30),

        Pose(id: "warrior1", name: "Warrior I", sanskrit: "Virabhadrasana I",
             symbol: "figure.strengthtraining.functional", stance: .standing, difficulty: .intermediate,
             focus: "Strength & stability",
             benefits: ["Strengthens legs", "Opens chest & hips", "Improves focus"],
             steps: ["Step one foot back, back toes at 45°.",
                     "Bend the front knee over the ankle.",
                     "Square the hips forward, reach arms overhead."],
             defaultHold: 30),

        Pose(id: "warrior2", name: "Warrior II", sanskrit: "Virabhadrasana II",
             symbol: "figure.martial.arts", stance: .standing, difficulty: .intermediate,
             focus: "Stamina & openness",
             benefits: ["Strengthens legs & ankles", "Opens hips & chest", "Builds endurance"],
             steps: ["From a wide stance, turn the front foot out 90°.",
                     "Bend the front knee, arms reach front and back at shoulder height.",
                     "Gaze over the front hand."],
             defaultHold: 30),

        Pose(id: "triangle", name: "Triangle Pose", sanskrit: "Trikonasana",
             symbol: "figure.flexibility", stance: .standing, difficulty: .intermediate,
             focus: "Side-body stretch",
             benefits: ["Stretches hips, hamstrings & spine", "Opens the chest", "Improves balance"],
             steps: ["From a wide stance, reach the front hand forward then down.",
                     "Rest the hand on shin, block or floor.",
                     "Extend the top arm up; open the chest skyward."],
             defaultHold: 30),

        Pose(id: "tree", name: "Tree Pose", sanskrit: "Vrksasana",
             symbol: "figure.yoga", stance: .balancing, difficulty: .beginner,
             focus: "Balance & focus",
             benefits: ["Improves balance", "Strengthens legs & core", "Calms & centers the mind"],
             steps: ["Shift weight onto one foot.",
                     "Place the other foot on the calf or inner thigh (never the knee).",
                     "Bring palms together at the heart or overhead."],
             defaultHold: 30),

        Pose(id: "eagle", name: "Eagle Pose", sanskrit: "Garudasana",
             symbol: "figure.yoga", stance: .balancing, difficulty: .advanced,
             focus: "Concentration",
             benefits: ["Strengthens ankles & calves", "Stretches shoulders & upper back", "Sharpens focus"],
             steps: ["Bend the knees, cross one thigh over the other.",
                     "Wrap the forearms, lifting the elbows.",
                     "Sink the hips and hold a steady gaze."],
             defaultHold: 20),

        Pose(id: "downdog", name: "Downward-Facing Dog", sanskrit: "Adho Mukha Svanasana",
             symbol: "figure.gymnastics", stance: .inversion, difficulty: .beginner,
             focus: "Full-body lengthening",
             benefits: ["Stretches hamstrings, calves & shoulders", "Strengthens arms", "Energizes the body"],
             steps: ["From hands and knees, tuck the toes and lift the hips up and back.",
                     "Press the floor away, lengthen the spine.",
                     "Let the heels reach toward the mat; soft knees are fine."],
             defaultHold: 30),

        Pose(id: "cobra", name: "Cobra Pose", sanskrit: "Bhujangasana",
             symbol: "figure.core.training", stance: .prone, difficulty: .beginner,
             focus: "Spine extension",
             benefits: ["Strengthens the spine", "Opens chest & shoulders", "Eases back stiffness"],
             steps: ["Lie face-down, hands under the shoulders.",
                     "Press the tops of the feet down.",
                     "Lift the chest, keeping the elbows hugged in."],
             defaultHold: 20),

        Pose(id: "updog", name: "Upward-Facing Dog", sanskrit: "Urdhva Mukha Svanasana",
             symbol: "figure.core.training", stance: .prone, difficulty: .intermediate,
             focus: "Chest opener",
             benefits: ["Strengthens arms & spine", "Opens chest & lungs", "Improves posture"],
             steps: ["From low plank, straighten the arms and roll the shoulders back.",
                     "Lift the thighs and hips off the floor.",
                     "Gaze forward and slightly up."],
             defaultHold: 15),

        Pose(id: "plank", name: "Plank Pose", sanskrit: "Phalakasana",
             symbol: "figure.core.training", stance: .prone, difficulty: .intermediate,
             focus: "Core stability",
             benefits: ["Strengthens core, arms & wrists", "Builds whole-body stability", "Improves posture"],
             steps: ["From hands and knees, step the feet back.",
                     "Stack shoulders over wrists, body in one line.",
                     "Engage the core and quads; gaze just past the hands."],
             defaultHold: 30),

        Pose(id: "child", name: "Child's Pose", sanskrit: "Balasana",
             symbol: "figure.mind.and.body", stance: .restorative, difficulty: .beginner,
             focus: "Rest & reset",
             benefits: ["Calms the nervous system", "Gently stretches hips & back", "Relieves fatigue"],
             steps: ["Kneel and sit the hips back toward the heels.",
                     "Fold forward, forehead toward the mat.",
                     "Extend the arms forward or rest them alongside the body."],
             defaultHold: 45),

        Pose(id: "cat", name: "Cat Pose", sanskrit: "Marjaryasana",
             symbol: "figure.barre", stance: .kneeling, difficulty: .beginner,
             focus: "Spinal mobility",
             benefits: ["Mobilizes the spine", "Eases back tension", "Links breath to movement"],
             steps: ["On hands and knees, exhale and round the spine.",
                     "Draw the navel up, tuck the chin.",
                     "Spread the shoulder blades wide."],
             defaultHold: 15),

        Pose(id: "cow", name: "Cow Pose", sanskrit: "Bitilasana",
             symbol: "figure.barre", stance: .kneeling, difficulty: .beginner,
             focus: "Spinal mobility",
             benefits: ["Mobilizes the spine", "Opens the chest", "Warms the back body"],
             steps: ["On hands and knees, inhale and drop the belly.",
                     "Lift the chest and tailbone.",
                     "Gaze gently forward and up."],
             defaultHold: 15),

        Pose(id: "lunge", name: "Low Lunge", sanskrit: "Anjaneyasana",
             symbol: "figure.strengthtraining.functional", stance: .kneeling, difficulty: .beginner,
             focus: "Hip flexor opener",
             benefits: ["Stretches hip flexors & quads", "Opens the chest", "Builds balance"],
             steps: ["Step one foot forward, lower the back knee.",
                     "Sink the hips forward and down.",
                     "Sweep the arms overhead and lift the chest."],
             defaultHold: 30),

        Pose(id: "seated_fold", name: "Seated Forward Bend", sanskrit: "Paschimottanasana",
             symbol: "figure.seated.side", stance: .seated, difficulty: .intermediate,
             focus: "Deep back stretch",
             benefits: ["Stretches hamstrings & spine", "Calms the mind", "Aids digestion"],
             steps: ["Sit with legs extended, flex the feet.",
                     "Hinge from the hips and reach forward.",
                     "Hold the shins, ankles or feet; keep the spine long."],
             defaultHold: 45),

        Pose(id: "butterfly", name: "Bound Angle", sanskrit: "Baddha Konasana",
             symbol: "figure.seated.side", stance: .seated, difficulty: .beginner,
             focus: "Hip opener",
             benefits: ["Opens hips & inner thighs", "Improves circulation", "Soothes the mind"],
             steps: ["Sit and bring the soles of the feet together.",
                     "Let the knees fall open.",
                     "Hold the feet and lengthen the spine tall."],
             defaultHold: 45),

        Pose(id: "seated_twist", name: "Seated Twist", sanskrit: "Ardha Matsyendrasana",
             symbol: "figure.seated.side", stance: .seated, difficulty: .intermediate,
             focus: "Spinal twist",
             benefits: ["Mobilizes the spine", "Aids digestion", "Relieves back tension"],
             steps: ["Sit tall, cross one foot over the opposite thigh.",
                     "Inhale to lengthen, exhale to twist toward the bent knee.",
                     "Use the opposite elbow as gentle leverage."],
             defaultHold: 30),

        Pose(id: "bridge", name: "Bridge Pose", sanskrit: "Setu Bandhasana",
             symbol: "figure.flexibility", stance: .supine, difficulty: .beginner,
             focus: "Back & glute strength",
             benefits: ["Strengthens back & glutes", "Opens the chest", "Energizes the body"],
             steps: ["Lie on your back, knees bent, feet hip-width.",
                     "Press the feet down and lift the hips.",
                     "Roll the shoulders under and clasp the hands if comfortable."],
             defaultHold: 30),

        Pose(id: "supine_twist", name: "Supine Twist", sanskrit: "Supta Matsyendrasana",
             symbol: "figure.flexibility", stance: .supine, difficulty: .beginner,
             focus: "Gentle release",
             benefits: ["Releases the lower back", "Stretches glutes & spine", "Calms the body"],
             steps: ["Lie on your back and hug one knee in.",
                     "Guide it across the body toward the floor.",
                     "Extend the opposite arm and turn the gaze away."],
             defaultHold: 30),

        Pose(id: "legs_up", name: "Legs Up the Wall", sanskrit: "Viparita Karani",
             symbol: "figure.mind.and.body", stance: .restorative, difficulty: .beginner,
             focus: "Deep restoration",
             benefits: ["Relieves tired legs", "Calms the nervous system", "Improves circulation"],
             steps: ["Sit beside a wall, then swing the legs up.",
                     "Rest the back on the floor, arms relaxed.",
                     "Soften and breathe slowly."],
             defaultHold: 60),

        Pose(id: "corpse", name: "Corpse Pose", sanskrit: "Savasana",
             symbol: "figure.mind.and.body", stance: .restorative, difficulty: .beginner,
             focus: "Total relaxation",
             benefits: ["Deep relaxation", "Integrates the practice", "Reduces stress"],
             steps: ["Lie flat on your back, legs relaxed open.",
                     "Arms by the sides, palms up.",
                     "Soften the whole body and let the breath settle."],
             defaultHold: 90),

        Pose(id: "boat", name: "Boat Pose", sanskrit: "Navasana",
             symbol: "figure.core.training", stance: .seated, difficulty: .advanced,
             focus: "Core power",
             benefits: ["Strengthens core & hip flexors", "Improves balance", "Builds focus"],
             steps: ["Sit and lean back slightly, lift the feet.",
                     "Straighten the legs toward a V-shape if possible.",
                     "Reach the arms forward, chest lifted."],
             defaultHold: 20),
    ]

    // MARK: Sequences

    static let sequences: [YogaSequence] = [
        YogaSequence(
            id: "sun_a", name: "Sun Salutation A", subtitle: "The classic flowing warm-up",
            symbol: "sun.max.fill", level: .beginner,
            steps: [
                SequenceStep(poseID: "mountain", seconds: 20),
                SequenceStep(poseID: "forward_fold", seconds: 20),
                SequenceStep(poseID: "plank", seconds: 20),
                SequenceStep(poseID: "cobra", seconds: 20),
                SequenceStep(poseID: "downdog", seconds: 40),
                SequenceStep(poseID: "forward_fold", seconds: 20),
                SequenceStep(poseID: "mountain", seconds: 20),
            ]),

        YogaSequence(
            id: "morning", name: "Morning Wake-Up", subtitle: "Gentle flow to start the day",
            symbol: "sunrise.fill", level: .beginner,
            steps: [
                SequenceStep(poseID: "child", seconds: 40),
                SequenceStep(poseID: "cat", seconds: 20),
                SequenceStep(poseID: "cow", seconds: 20),
                SequenceStep(poseID: "downdog", seconds: 40),
                SequenceStep(poseID: "lunge", seconds: 30),
                SequenceStep(poseID: "forward_fold", seconds: 30),
                SequenceStep(poseID: "mountain", seconds: 30),
                SequenceStep(poseID: "tree", seconds: 30),
            ]),

        YogaSequence(
            id: "strength", name: "Power & Strength", subtitle: "Build heat and stability",
            symbol: "flame.fill", level: .intermediate,
            steps: [
                SequenceStep(poseID: "chair", seconds: 30),
                SequenceStep(poseID: "warrior1", seconds: 30),
                SequenceStep(poseID: "warrior2", seconds: 30),
                SequenceStep(poseID: "triangle", seconds: 30),
                SequenceStep(poseID: "plank", seconds: 40),
                SequenceStep(poseID: "updog", seconds: 20),
                SequenceStep(poseID: "boat", seconds: 30),
                SequenceStep(poseID: "bridge", seconds: 30),
            ]),

        YogaSequence(
            id: "balance", name: "Balance & Focus", subtitle: "Steady the body and the mind",
            symbol: "scope", level: .intermediate,
            steps: [
                SequenceStep(poseID: "mountain", seconds: 30),
                SequenceStep(poseID: "tree", seconds: 40),
                SequenceStep(poseID: "warrior2", seconds: 30),
                SequenceStep(poseID: "eagle", seconds: 30),
                SequenceStep(poseID: "triangle", seconds: 30),
                SequenceStep(poseID: "boat", seconds: 30),
            ]),

        YogaSequence(
            id: "evening", name: "Evening Wind-Down", subtitle: "Release tension before sleep",
            symbol: "moon.stars.fill", level: .beginner,
            steps: [
                SequenceStep(poseID: "cat", seconds: 20),
                SequenceStep(poseID: "cow", seconds: 20),
                SequenceStep(poseID: "child", seconds: 45),
                SequenceStep(poseID: "seated_fold", seconds: 45),
                SequenceStep(poseID: "butterfly", seconds: 45),
                SequenceStep(poseID: "supine_twist", seconds: 60),
                SequenceStep(poseID: "legs_up", seconds: 60),
                SequenceStep(poseID: "corpse", seconds: 90),
            ]),

        YogaSequence(
            id: "hips", name: "Hip Opener Flow", subtitle: "Deep release for tight hips",
            symbol: "leaf.fill", level: .intermediate,
            steps: [
                SequenceStep(poseID: "downdog", seconds: 30),
                SequenceStep(poseID: "lunge", seconds: 40),
                SequenceStep(poseID: "warrior2", seconds: 30),
                SequenceStep(poseID: "triangle", seconds: 30),
                SequenceStep(poseID: "butterfly", seconds: 45),
                SequenceStep(poseID: "seated_twist", seconds: 30),
                SequenceStep(poseID: "supine_twist", seconds: 45),
            ]),
    ]
}
