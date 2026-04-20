import SwiftUI

struct RecordView: View {
    var hideFooter: Bool = false

    @State private var selectedTask: TaskType? = .studying
    @State private var descriptionText: String = ""

    enum TaskType: String, CaseIterable, Identifiable {
        case studying = "Studying"
        case writing = "Writing"
        case coding = "Coding"
        case workout = "Workout"
        case meditation = "Meditation"
        case add = "Add"

        var id: String { rawValue }
        var emoji: String {
            switch self {
            case .studying: return "📚"
            case .writing: return "✏️"
            case .coding: return "💻"
            case .workout: return "💪"
            case .meditation: return "🧘"
            case .add: return "+"
            }
        }
    }

    var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.09, blue: 0.14)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                headerSection

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        recordNewTaskButton
                        taskSelectionCard
                        descriptionField
                        startRecordingButton
                        tipsCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }

                if !hideFooter {
                    customFooter
                }
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack {
            Text("L O C K D")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.white)
                .shadow(color: Color(red: 0.82, green: 0.60, blue: 0.76).opacity(0.7), radius: 7)

            Spacer()

            HStack(spacing: 20) {
                Image(systemName: "bell.fill")
                Image(systemName: "line.3.horizontal")
            }
            .foregroundColor(.white)
            .font(.system(size: 20))
        }
        .padding(.horizontal, 25)
        .padding(.top, 10)
    }

    // MARK: - Record New Task Button
    private var recordNewTaskButton: some View {
        HStack(spacing: 8) {
            Image(systemName: "record.circle")
                .foregroundColor(.white)
            Text("Record New Task")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(
            Capsule()
                .fill(Color(red: 0.23, green: 0.07, blue: 0.42))
                .overlay(Capsule().stroke(Color.white.opacity(0.6), lineWidth: 0.6))
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: - Task Selection Card
    private var taskSelectionCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Task Selection")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            // Emoji grid row
            HStack(spacing: 18) {
                ForEach(TaskType.allCases, id: \.self) { task in
                    taskEmoji(task)
                }
            }

            // Selected label
            Text(selectedTask?.rawValue ?? "")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(red: 0.86, green: 0.69, blue: 0.96))
                .padding(.top, 6)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.16, green: 0.13, blue: 0.21))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                )
        )
    }

    private func taskEmoji(_ task: TaskType) -> some View {
        Button {
            selectedTask = task == .add ? selectedTask : task
        } label: {
            ZStack {
                Circle()
                    .fill(task == selectedTask ? Color(red: 0.32, green: 0.42, blue: 1) : Color(red: 0.23, green: 0.07, blue: 0.42))
                    .frame(width: 48, height: 48)
                    .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 0.6))
                Text(task.emoji)
                    .font(.system(size: 24))
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Description Field
    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.16, green: 0.13, blue: 0.21))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                    )
                    .frame(height: 56)

                if descriptionText.isEmpty {
                    Text("E.g., Practicing French Speaking…")
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.horizontal, 14)
                }

                TextField("", text: $descriptionText)
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
            }
        }
    }

    // MARK: - Start Recording Button
    private var startRecordingButton: some View {
        Button {
            // Hook up your recording action here
        } label: {
            HStack {
                Image(systemName: "mic.circle.fill")
                Text("Start Recording")
                    .font(.system(size: 18, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.96, green: 0.43, blue: 0.22))
                    .shadow(color: Color(red: 0.96, green: 0.43, blue: 0.22).opacity(0.5), radius: 12, x: 0, y: 6)
            )
            .foregroundColor(.white)
        }
    }

    // MARK: - Tips Card
    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tips")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 8) {
                tipRow("Earn 1 point per minute of focused work")
                tipRow("Maintain your streak by locking-in")
                tipRow("Share your work and inspire others")
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.16, green: 0.13, blue: 0.21))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.6), lineWidth: 0.6)
                )
        )
    }

    private func tipRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "sparkles")
                .foregroundColor(Color(red: 0.86, green: 0.69, blue: 0.96))
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 14))
        }
    }

    // MARK: - Footer (optional)
    private var customFooter: some View {
        HStack {
            Spacer()
            Image(systemName: "house.fill")
            Spacer()
            Image(systemName: "trophy")
            Spacer()
            Image(systemName: "person.fill")
            Spacer()
        }
        .padding(.top, 15)
        .padding(.bottom, 30)
        .background(Color(red: 0.12, green: 0.09, blue: 0.14))
        .foregroundColor(.white)
        .font(.system(size: 24))
    }
}

#Preview {
    RecordView()
}