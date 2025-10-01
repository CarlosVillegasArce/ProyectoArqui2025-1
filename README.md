# Procesador Multicycle - Proyecto de Arquitectura de Computadoras

Este proyecto consiste en el desarrollo de un **Procesador Multicycle** personalizado que implementa instrucciones adicionales y soporte para operaciones de punto flotante bajo el estándar IEEE 754, así como una interfaz de salida mediante display para la **placa Basys 3**.

## 🔧 Características principales

- ✅ Arquitectura **Multicycle** (Procesador en múltiples ciclos de reloj)
- 🔁 Nuevos **estados de control** agregados:
  - `IsMul` para multiplicación entera.
  - `IsMul64` para multiplicación de 64 bits.
- 🧮 Implementación de operaciones **Floating Point** bajo el estándar **IEEE 754 (simple precisión)**
- 💡 Interfaz con **Display de la Basys 3** para mostrar resultados en tiempo real

## 📦 Componentes implementados

- Unidad de Control FSM modificada
- Unidad de punto flotante (con sumador/restador IEEE 754)
- Multiplicador de 64 bits
- Módulo de visualización en 7 segmentos para Basys 3
- Banco de registros extendido para punto flotante

## 💻 Herramientas utilizadas

- **Vivado Design Suite**
- **Verilog HDL**
- **Placa FPGA Digilent Basys 3**
- Simulaciones en testbench

## 👨‍💻 Integrantes

- **Carlos Villegas Arce**
- **Hanks Vargas**

