//
//  ContentView.swift
//  SwiftSpaceBattle
//
//  Created by Julio César Fernández Muñoz on 4/1/25.
//

import SwiftUI
import SpriteKit

// Máquina de estado para gestionar los diferentes estados del juego
// - `.game`: se muestra la escena del juego
// - `.menu`: se muestra el menú principal
enum GameState {
    case game, menu
}

struct ContentView: View {
    // Suscripción a las notificaciones de "gameover" enviadas por la escena del juego.
    // Cuando la escena envía esta notificación, se cambia el estado del juego a "menu" tras una pausa.
    private let gameOver = NotificationCenter.default
        .publisher(for: .gameover)
    
    @State private var state: GameState = .game // Estado inicial: comienza en el juego
    
    var body: some View {
        ZStack {
            // Cambia la vista según el estado actual
            switch state {
                case .game:
                    // Muestra la vista del juego con la escena SpriteKit
                    SpriteView(scene: GameScene.newGame)
                case .menu:
                    // Muestra el menú principal
                    menu
            }
        }
        // Escucha la notificación de "gameover" y cambia al menú después de 2 segundos
        .onReceive(gameOver) { _ in
            Task {
                try await Task.sleep(for: .seconds(2)) // Pausa de 2 segundos antes de mostrar el menú
                state = .menu // Cambia al estado del menú principal
            }
        }
        // Añade una animación al cambiar de estado (suave transición)
        .animation(.default, value: state)
        // Oculta la barra de estado para un modo de pantalla completa
        .statusBarHidden()
        .ignoresSafeArea() // Asegura que el contenido ocupe toda la pantalla
    }
    
    // Vista del menú principal
    var menu: some View {
        ZStack {
            // Fondo de imagen del menú
            Image(.bkgd0)
                .resizable()
            
            // Botón de inicio para volver al juego
            Button {
                state = .game // Cambia el estado para comenzar el juego
            } label: {
                Text("Start") // Texto del botón
            }
            .buttonStyle(.borderedProminent) // Botón con estilo prominente
            .buttonBorderShape(.capsule) // Forma de cápsula para el botón
            .controlSize(.large) // Botón grande
        }
    }
}
#Preview {
    ContentView()
}
