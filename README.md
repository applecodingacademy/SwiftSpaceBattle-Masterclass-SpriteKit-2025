# 🎮 Crea un Juego en Swift para iPhone con SpriteKit 🚀  

Este repositorio contiene el proyecto del juego creado durante la masterclass gratuita **"Crea un Juego en Swift para iPhone en SpriteKit"**, ofrecida por **AC Academy**. Puedes ver la masterclass completa en el siguiente enlace:  
🔗 [Ver Masterclass en YouTube](https://www.youtube.com/live/kx2pBCK3jgI)  

Este proyecto es una muestra práctica de lo que puedes aprender en el **Swift Mastery Program**, el programa definitivo para alcanzar la excelencia como desarrollador iOS y dominar el ecosistema Apple de manera profesional.  

🔗 **Más información sobre el Swift Mastery Program:**  
👉 [https://acoding.academy/smp25](https://acoding.academy/smp25)  

---

## 📚 **Acerca de la Masterclass**  

Esta clase ha sido impartida por **Julio César Fernández**, Director Académico de **AC Academy** y referente en desarrollo Apple. Puedes seguir a Julio en **X**:  
🕊️ **@jcfmunoz**  

La masterclass cubre desde los fundamentos hasta patrones avanzados de desarrollo de juegos 2D utilizando SpriteKit integrado en SwiftUI. ¡Todo con un enfoque práctico y moderno!  

---

## 🎮 **¿Qué hace este Proyecto?**  

Este proyecto es un ejemplo completo de cómo construir un **juego espacial de acción** con efectos visuales avanzados y una jugabilidad atractiva.  

### ✨ **Características Principales del Juego**  

1. **🚀 Nave Espacial Controlable:**  
   La nave se mueve según el deslizamiento del dedo en la pantalla y dispara automáticamente al tocar.  

2. **👾 Patrón de Enemigos Avanzado:**  
   Los enemigos tienen comportamientos complejos:  
   - **Patrón Wave:** Movimiento ondulado descendente como en juegos clásicos tipo Terra Cresta.  
   - Disparos automáticos mientras se acercan al jugador.  

3. **🌀 Scroll Infinito:**  
   Efecto de scroll infinito con múltiples capas de fondo para simular profundidad mediante paralaje.  

4. **💥 Sistema de Colisiones:**  
   - Los disparos láser destruyen enemigos al contacto.  
   - Si la nave colisiona con un enemigo, el juego termina y se notifica a la interfaz principal para mostrar el menú de reinicio.  

5. **🛠️ Uso de Notificaciones:**  
   - La escena envía una notificación `.gameover` al sistema para reiniciar la partida y mostrar el menú mediante `NotificationCenter`.  

---

## 🛠️ **Tecnologías Utilizadas**  

- **Swift 6 y SpriteKit**: Para la lógica de juego y la representación 2D.  
- **SwiftUI**: Para la creación de la interfaz principal y el manejo de la máquina de estados del juego.  
- **GameplayKit**: Para generar comportamientos aleatorios como la variación en los patrones de enemigos.  

---

## 📂 **Estructura del Proyecto**  

- `ContentView.swift`: La interfaz principal del juego construida en **SwiftUI**.  
  - Incluye una **máquina de estado** que alterna entre la vista del juego y el menú principal.  
  - Utiliza **`SpriteView`** para mostrar la escena `GameScene.sks`.  
  - Escucha la notificación `gameover` y vuelve al menú al perder la partida.  
- `GameScene.swift`: La lógica principal del juego en **SpriteKit**.  
  - Configura la nave con restricciones de movimiento y física.  
  - Crea enemigos con comportamientos ondulados (`wave`).  
  - Gestiona el scroll infinito y el disparo láser.  
  - Detecta colisiones con el sistema de categorías binarias `UInt32`.  
- `GameScene.sks`: Archivo de la escena que define los elementos visuales, como la nave y las capas de fondo.  
- `PhysicsCategory.swift`: Define las categorías de colisión del juego (nave, láser, enemigos) en formato binario.  

---

## ⚙️ **Cómo Ejecutar el Proyecto**  

1. Clona este repositorio:  
   ```bash
   git clone https://github.com/tuusuario/SwiftSpaceBattle.git
   cd SwiftSpaceBattle
   ```
2.	Abre el proyecto en Xcode.
3.	Compila y ejecuta en un simulador o dispositivo real (recomendado para una mejor experiencia).

## 🎓 ¿Quieres Más?

Si te ha gustado esta masterclass, ¡esto es solo el principio! El Swift Mastery Program te llevará más allá, enseñándote cómo crear aplicaciones iOS con SwiftUI, SpriteKit, Apple Intelligence y más:

🔗 Descubre el programa completo:
👉 [https://acoding.academy/smp25](https://acoding.academy/smp25)  

¡Descarga el código, prueba el juego y comparte tus resultados en redes! No olvides mencionar a @jcfmunoz para mostrar tu progreso. 🚀 ¡A crear grandes juegos!
