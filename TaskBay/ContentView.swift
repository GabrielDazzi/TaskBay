//
//  ContentView.swift
//  TaskBay
//
//  Created by Gabriel Bonomo Dazzi on 23/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""
    @State private var searchText = ""
    @State private var editingTask: TaskItem?
    @State private var editedTaskTitle = ""

    var body: some View {
        ZStack {
            Color(NSColor.windowBackgroundColor)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("TaskBay")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                    .padding(.top, 20)

                HStack(spacing: 12) {
                    TextField("Adicione uma nova tarefa...", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity)

                    Button(action: {
                        guard !newTaskTitle.isEmpty else { return }
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)

                TextField("Buscar tarefa...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 24)

                List {
                    ForEach(viewModel.tasks.filter {
                        searchText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchText)
                    }) { task in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)

                            HStack {
                                Button(action: {
                                    viewModel.toggleTask(task)
                                }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                        .font(.title3)
                                }
                                .buttonStyle(.plain)

                                if editingTask?.id == task.id {
                                    TextField("Editar tarefa", text: $editedTaskTitle)
                                        .textFieldStyle(.plain)
                                        .font(.system(size: 14))
                                        .padding(.vertical, 6)

                                    Button(action: {
                                        viewModel.updateTask(task, with: editedTaskTitle)
                                        editingTask = nil
                                    }) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.green)
                                    }

                                    Button(action: {
                                        editingTask = nil
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.red)
                                    }

                                } else {
                                    Text(task.title)
                                        .strikethrough(task.isCompleted)
                                        .foregroundColor(task.isCompleted ? .gray : .primary)
                                        .font(.system(size: 18))
                                        .padding(.vertical, 2)

                                    Spacer()

                                    Button {
                                        editingTask = task
                                        editedTaskTitle = task.title
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.blue)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                        .frame(height: 60)
                        .padding(.top, 10)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
                .listStyle(.plain)
                .cornerRadius(16)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .frame(minWidth: 500, minHeight: 600)
    }
}

#Preview {
    ContentView()
}
