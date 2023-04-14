//
//  ContentView.swift
//  TodoApp
//
//  Created by user219285 on 4/3/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var iconSettings: IconNames
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(todos, id: \.self) {todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(self.colorize(priority: todo.priority ?? "Normal"), lineWidth: 0.75)
                                )
                        }
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: deleteTodo)
                }
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                    trailing:
                    Button(action: {
                        showingSettingsView.toggle()
                    }) {
                        Image(systemName: "paintbrush")
                            .imageScale(.large)
                    }
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .sheet(isPresented: $showingSettingsView) {
                        SettingsView().environmentObject(self.iconSettings) 
                    }
                )
                //MARK: - NO todo items
                if todos.count == 0 {
                    EmptyListView()
                }
            }
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView().environment(\.managedObjectContext, managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.25 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 70, height: 70, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(animatingButton ? 0.15 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 90, height: 90, alignment: .center)
                    }
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animatingButton)
                    
                    Button(action: {
                        showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(
                                Circle()
                                    .fill(colorBase)
                            )
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .onAppear {
                        animatingButton.toggle()
                    }
                }
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //MARK: - Functions
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
