# Socio App - Aplicación de Gestión de Socios

Una aplicación móvil moderna desarrollada con Flutter para la gestión integral de socios, cuotas y pagos.

## 🚀 Características

### ✨ **Nueva UI Moderna y Profesional**
- **Diseño inspirado en fintechs** como Ualá y NaranjaX
- **Tema personalizado** con colores profesionales y gradientes modernos
- **Animaciones suaves** y transiciones elegantes
- **Componentes reutilizables** con diseño consistente

### 🔐 **Sistema de Autenticación**
- **Login moderno** con validaciones y feedback visual
- **Registro de usuarios** con formulario completo y validaciones
- **Gestión de sesiones** con GetX
- **Recuperación de contraseña** (en desarrollo)

### 🏠 **Dashboard Principal**
- **Tarjeta de socio** estilo tarjeta de crédito moderna
- **Anuncios destacados** con diseño atractivo
- **Gestión de cuotas** con resumen visual y estado
- **Historial de pagos** con navegación intuitiva

### 📱 **Navegación Mejorada**
- **Bottom navigation** personalizada con animaciones
- **Transiciones suaves** entre pantallas
- **Indicadores visuales** para notificaciones
- **Responsive design** para diferentes tamaños de pantalla

## 🛠️ Tecnologías Utilizadas

- **Flutter** - Framework de desarrollo móvil
- **GetX** - Gestión de estado y navegación
- **Firebase** - Backend y autenticación
- **Material Design 3** - Sistema de diseño moderno
- **Font Awesome** - Iconografía profesional

## 🎨 **Características de Diseño**

### **Paleta de Colores**
- **Primary**: Indigo moderno (#6366F1)
- **Secondary**: Violeta (#8B5CF6)
- **Accent**: Cyan (#06B6D4)
- **Success**: Verde esmeralda (#10B981)
- **Warning**: Ámbar (#F59E0B)
- **Error**: Rojo (#EF4444)

### **Componentes Modernos**
- **Cards con sombras** y bordes redondeados
- **Gradientes** para elementos destacados
- **Tipografía jerárquica** clara y legible
- **Espaciado consistente** siguiendo principios de diseño
- **Iconografía contextual** para mejor UX

## 📁 Estructura del Proyecto

```
lib/
├── config/
│   └── themes/
│       └── app_theme.dart          # Tema personalizado
├── src/
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── auth_screen/        # Pantallas de autenticación
│   │   │   ├── home_screen/        # Pantalla principal
│   │   │   └── ...
│   │   ├── views/
│   │   │   ├── inicio_views/       # Vista de inicio
│   │   │   └── ...
│   │   └── ...
│   └── ...
```

## 🚀 **Cómo Ejecutar**

1. **Clonar el repositorio**
   ```bash
   git clone [url-del-repositorio]
   cd socio_app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   - Agregar `google-services.json` en `android/app/`
   - Configurar `firebase_options.dart`

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 📱 **Capturas de Pantalla**

### **Login Moderno**
- Gradiente de fondo elegante
- Logo circular con sombras
- Campos de entrada estilizados
- Validaciones en tiempo real

### **Dashboard Principal**
- Tarjeta de socio tipo "credit card"
- Anuncios con gradientes y badges
- Resumen de cuotas con métricas visuales
- Navegación inferior personalizada

### **Formulario de Registro**
- Layout de dos columnas para nombre/apellido
- Validaciones completas de formulario
- Checkbox de términos y condiciones
- Botones con estados de carga

## 🔧 **Configuración del Tema**

El tema personalizado se encuentra en `lib/src/config/themes/app_theme.dart` y incluye:

- **Colores del sistema** con semántica clara
- **Tipografía** con jerarquías definidas
- **Componentes** (botones, inputs, cards)
- **Sombras** personalizadas para profundidad
- **Gradientes** para elementos destacados

## 📈 **Próximas Mejoras**

- [ ] **Modo oscuro** para mejor experiencia nocturna
- [ ] **Animaciones más complejas** con Lottie
- [ ] **Temas personalizables** por usuario
- [ ] **Accesibilidad mejorada** con VoiceOver/TalkBack
- [ ] **Tests de UI** automatizados

## 🤝 **Contribuir**

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 **Licencia**

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 **Desarrollado por**

[Tu Nombre] - Desarrollador Flutter

---

**¡Gracias por usar Socio App! 🎉**
