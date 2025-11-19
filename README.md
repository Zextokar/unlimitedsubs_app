# UnlimitedSubs App 📱

Una aplicación móvil moderna y fluida desarrollada en **Flutter** para el consumo de contenido de fansub. Diseñada con un enfoque "Premium", ofrece una experiencia de usuario inmersiva con un tema oscuro elegante (Dark Navy), animaciones fluidas y una gestión eficiente de datos.

## ✨ Características Principales

### 🏠 Pantalla de Inicio (Home)
* **Hero Banner Dinámico:** Carrusel automático en la parte superior mostrando las 3 series más recientes.
* **Estantes de Contenido:** Secciones organizadas en cuadrículas verticales (Últimos Episodios, Recomendaciones, Películas, Música, etc.).
* **Visto Recientemente:** Historial automático que recuerda los últimos episodios o películas que has visto.
* **Mi Lista:** Acceso rápido a tus series y películas favoritas guardadas.
* **Pull-to-Refresh:** Desliza hacia abajo para recargar todo el catálogo y buscar nuevo contenido.
* **Indicadores de Novedad:** Badge "NUEVO" automático para contenido lanzado en los últimos 7 días.

### 🔍 Búsqueda Avanzada
* **Búsqueda Global:** Busca series, películas, especiales y música desde un solo lugar.
* **Filtros Inteligentes:** Chips de filtrado para refinar los resultados por categoría (Todo, Series, Películas, Especiales, Música).
* **Resultados Visuales:** Lista limpia con miniaturas 16:9.

### 📺 Reproductor Multimedia
* **Soporte Web Embebido:** Reproducción de videos (VK, OK.ru, etc.) directamente en la app mediante `WebView`.
* **Modo Cine:** Pantalla completa automática, orientación horizontal forzada y ocultación de barras de sistema para una inmersión total.
* **Autoplay:** El video comienza automáticamente al entrar.

### 📚 Biblioteca y Organización
* **Hubs Visuales:** Navegación por categorías (Series, Películas, Especiales, Música, Libros) mediante tarjetas grandes e iconografía/logos personalizados.
* **Detalles Ricos:**
    * **Series:** Sinopsis, metadatos (año, calidad, rating), y lista de episodios con estado de "visto" (futuro).
    * **Películas:** Pantalla dedicada con sinopsis, botón de reproducción, añadir a favoritos y series relacionadas.
    * **Especiales:** Soporte tanto para especiales de un solo capítulo como para mini-series.

### ⚙️ Configuración y Sistema
* **Tema Dark Navy:** Diseño visual cuidado con paleta de colores azul marino/grafito (`#0D1117`) para reducir la fatiga visual.
* **Gestión de Caché:** Opción para limpiar el caché de imágenes y liberar espacio.
* **Actualizaciones:** Verificación de nuevas versiones directamente desde GitHub Releases, mostrando el changelog (notas de versión) en la app.
* **Feedback:** Enlace directo para enviar correos de soporte.

---

## 🛠️ Tecnologías Utilizadas

* **Framework:** [Flutter](https://flutter.dev/)
* **Lenguaje:** Dart
* **Gestión de Estado:** [Riverpod](https://riverpod.dev/) (v2.5.1)
* **Red:** `http` para consumo de API JSON.
* **Imágenes:** `cached_network_image` para carga eficiente y caché.
* **Persistencia Local:** `shared_preferences` para Favoritos e Historial.
* **Navegador Web:** `webview_flutter` para el reproductor de video.
* **UI/UX:**
    * `shimmer` para efectos de carga (esqueletos).
    * `smooth_page_indicator` para carruseles.
    * Animaciones `Hero` para transiciones de imágenes.
* **Utilidades:** `url_launcher`, `flutter_cache_manager`, `flutter_markdown`.

---

## 🚀 Instalación y Ejecución

### Requisitos Previos
* Flutter SDK instalado (versión compatible con Dart 3).
* Un dispositivo Android/iOS o emulador.
