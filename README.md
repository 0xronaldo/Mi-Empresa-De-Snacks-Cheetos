# Tienda Papas Fritas - Sistema de Mercado de Snacks 🍟

Contrato inteligente en Move para la blockchain Sui que implementa un mercado completo de snacks con gestión de vendedores, clientes, inventarios y sistema de lealtad.

## 📋 Descripción General

Este contrato simula un mercado de snacks donde vendedores pueden gestionar inventarios y clientes pueden comprar productos. Incluye un sistema de niveles de lealtad que otorga descuentos progresivos basados en el volumen de compras.

---

## 🔧 Funciones Principales

### 1. `crear_mercado`
**Descripción:** Inicializa un nuevo mercado de snacks con registros vacíos de vendedores y clientes.

**Parámetros:**
- `nombre: String` - Nombre del mercado
- `ctx: &mut TxContext` - Contexto de la transacción

**Uso:** Crea la estructura principal del mercado y la transfiere al creador.

**Ejemplo:**
```move
crear_mercado(string::utf8(b"Mercado Central Snacks"), ctx);
```

---

### 2. `registrar_vendedor`
**Descripción:** Agrega un nuevo vendedor al mercado con inventario vacío.

**Parámetros:**
- `mercado: &mut MercadoSnacks` - Referencia mutable al mercado
- `nombre: String` - Nombre del vendedor
- `id_vendedor: u16` - ID único del vendedor (debe ser único)

**Uso:** Registra vendedores que podrán gestionar inventarios y realizar ventas.

**Error:** Falla si el ID ya existe (`E_ID_VENDEDOR_EXISTE`)

**Ejemplo:**
```move
registrar_vendedor(&mut mercado, string::utf8(b"Juan Snacks"), 1);
```

---

### 3. `registrar_cliente`
**Descripción:** Agrega un nuevo cliente al mercado con nivel inicial "Casual".

**Parámetros:**
- `mercado: &mut MercadoSnacks` - Referencia mutable al mercado
- `nombre: String` - Nombre del cliente
- `id_cliente: u16` - ID único del cliente (debe ser único)

**Uso:** Registra clientes que podrán comprar snacks y acumular beneficios de lealtad.

**Error:** Falla si el ID ya existe (`E_ID_CLIENTE_EXISTE`)

**Nivel inicial:** Casual (0% descuento)

---

### 4. `agregar_stock`
**Descripción:** Añade cantidad de un tipo de snack al inventario de un vendedor específico.

**Parámetros:**
- `mercado: &mut MercadoSnacks` - Referencia mutable al mercado
- `id_vendedor: u16` - ID del vendedor
- `tipo_snack: String` - Nombre del snack (ej: "Cheetos", "Papas Fritas")
- `cantidad: u64` - Cantidad a agregar (debe ser > 0)

**Uso:** Los vendedores reabastecen su inventario.

**Errores:**
- `E_ID_VENDEDOR_NO_EXISTE` - Vendedor no registrado
- `E_CANTIDAD_INVALIDA` - Cantidad debe ser mayor a 0

**Ejemplo:**
```move
agregar_stock(&mut mercado, 1, string::utf8(b"Cheetos"), 100);
```

---

### 5. `comprar_snack`
**Descripción:** Procesa una compra de snacks, actualizando inventario, ventas, historial de compras y aplicando descuentos según nivel de lealtad del cliente.

**Parámetros:**
- `mercado: &mut MercadoSnacks` - Referencia mutable al mercado
- `id_vendedor: u16` - ID del vendedor
- `id_cliente: u16` - ID del cliente
- `tipo_snack: String` - Tipo de snack a comprar
- `cantidad: u64` - Cantidad a comprar

**Retorna:** `String` - Mensaje detallado de la compra con costo y descuento aplicado

**Uso:** Función principal para realizar transacciones de compra.

**Lógica:**
1. Verifica existencia de vendedor, cliente y disponibilidad del snack
2. Calcula descuento según nivel del cliente
3. Reduce inventario del vendedor
4. Incrementa ventas del vendedor
5. Actualiza compras totales e historial del cliente
6. Evalúa y actualiza nivel de lealtad del cliente si corresponde

**Errores:**
- `E_ID_VENDEDOR_NO_EXISTE`
- `E_ID_CLIENTE_NO_EXISTE`
- `E_SNACK_NO_DISPONIBLE` - Snack no existe o sin stock suficiente
- `E_CANTIDAD_INVALIDA`

**Ejemplo:**
```move
comprar_snack(&mut mercado, 1, 1, string::utf8(b"Cheetos"), 10);
// Retorna: "Compra de 10 Cheetos, Costo: 10, Descuento: 0%"
```

---

### 6. `obtener_estado_cliente`
**Descripción:** Consulta información completa de un cliente: nombre, nivel de lealtad y compras totales.

**Parámetros:**
- `mercado: &MercadoSnacks` - Referencia al mercado
- `id_cliente: u16` - ID del cliente a consultar

**Retorna:** `String` - Información formateada del cliente

**Uso:** Permite verificar el estado y progreso de un cliente en el sistema de lealtad.

**Error:** `E_ID_CLIENTE_NO_EXISTE`

**Ejemplo de retorno:**
```
"Cliente: Maria Lopez, Nivel: Fanatico, Compras Totales: 150"
```

---

### 7. `eliminar_vendedor`
**Descripción:** Remueve un vendedor del mercado.

**Parámetros:**
- `mercado: &mut MercadoSnacks` - Referencia mutable al mercado
- `id_vendedor: u16` - ID del vendedor a eliminar

**Uso:** Elimina vendedores que ya no operan en el mercado.

**Error:** `E_ID_VENDEDOR_NO_EXISTE`

**Nota:** El inventario del vendedor se pierde al eliminarlo.

---

### 8. `eliminar_cliente`
**Descripción:** Remueve un cliente del mercado.

**Parámetros:**
- `mercado: &mut MercadoSnacks` - Referencia mutable al mercado
- `id_cliente: u16` - ID del cliente a eliminar

**Uso:** Elimina clientes del sistema.

**Error:** `E_ID_CLIENTE_NO_EXISTE`

**Nota:** El historial de compras del cliente se pierde al eliminarlo.

---

### 9. `eliminar_mercado`
**Descripción:** Destruye completamente el mercado y todos sus datos.

**Parámetros:**
- `mercado: MercadoSnacks` - Objeto mercado a eliminar (consume el objeto)

**Uso:** Cierra permanentemente el mercado. Esta acción es irreversible.

**Nota:** Todos los vendedores, clientes e inventarios se pierden.

---

## 🎯 Sistema de Niveles de Lealtad

El sistema automáticamente promociona clientes según sus compras totales:

| Nivel | Descuento | Requisito | Descripción |
|-------|-----------|-----------|-------------|
| **Casual** | 0% | Inicial | Clientes nuevos sin beneficios |
| **Fanático** | 5% | ≥ 100 compras | Cliente frecuente con descuento moderado |
| **Leyenda** | 15% | ≥ 500 compras | Cliente VIP con máximo descuento |

**Lógica de promoción:**
- Al alcanzar 100 compras totales → Promoción a Fanático (5% descuento)
- Al alcanzar 500 compras totales → Promoción a Leyenda (15% descuento)
- Las promociones se evalúan automáticamente en cada compra

---

## 📊 Estructuras de Datos

### MercadoSnacks
```move
public struct MercadoSnacks has key, store {
    id: UID,
    nombre_mercado: String,
    vendedores: VecMap<u16, Vendedor>,  // ID → Vendedor
    clientes: VecMap<u16, Cliente>       // ID → Cliente
}
```

### Vendedor
```move
public struct Vendedor has store, drop, copy {
    nombre: String,
    inventario: VecMap<String, u64>,     // Tipo snack → Cantidad
    ventas_totales: u64                  // Total unidades vendidas
}
```

### Cliente
```move
public struct Cliente has store, drop, copy {
    nombre: String,
    nivel: Nivel,                        // Nivel de lealtad
    compras_totales: u64,                // Total unidades compradas
    historial_compras: vector<String>    // Registro de compras
}
```

---

## 🚀 Flujo de Uso Típico

### Configuración Inicial
1. **Crear mercado** con `crear_mercado()`
2. **Registrar vendedores** con `registrar_vendedor()`
3. **Registrar clientes** con `registrar_cliente()`
4. **Agregar inventario** con `agregar_stock()`

### Operación Normal
5. **Procesar compras** con `comprar_snack()`
6. **Consultar estado** de clientes con `obtener_estado_cliente()`

### Gestión
7. **Eliminar** vendedores/clientes inactivos con `eliminar_vendedor()` / `eliminar_cliente()`
8. **Cerrar mercado** con `eliminar_mercado()` si es necesario

---

## 💡 Ejemplo Completo de Uso

```move
// 1. Crear mercado
crear_mercado(string::utf8(b"Snacks Express"), ctx);

// 2. Registrar vendedor
registrar_vendedor(&mut mercado, string::utf8(b"Pedro's Snacks"), 1);

// 3. Agregar stock
agregar_stock(&mut mercado, 1, string::utf8(b"Cheetos"), 500);
agregar_stock(&mut mercado, 1, string::utf8(b"Papas Fritas"), 300);

// 4. Registrar cliente
registrar_cliente(&mut mercado, string::utf8(b"Ana Garcia"), 1);

// 5. Primera compra (nivel Casual, sin descuento)
comprar_snack(&mut mercado, 1, 1, string::utf8(b"Cheetos"), 50);
// Costo: 50, Descuento: 0%

// 6. Más compras para alcanzar nivel Fanático
comprar_snack(&mut mercado, 1, 1, string::utf8(b"Papas Fritas"), 60);
// Total compras: 110 → Promoción a Fanático automática

// 7. Nueva compra con descuento
comprar_snack(&mut mercado, 1, 1, string::utf8(b"Cheetos"), 100);
// Costo: 95, Descuento: 5%

// 8. Consultar estado
obtener_estado_cliente(&mercado, 1);
// "Cliente: Ana Garcia, Nivel: Fanatico, Compras Totales: 210"
```

---

## ⚠️ Errores y Validaciones

| Código de Error | Descripción |
|----------------|-------------|
| `E_ID_VENDEDOR_EXISTE` | ID de vendedor duplicado |
| `E_ID_VENDEDOR_NO_EXISTE` | Vendedor no encontrado |
| `E_ID_CLIENTE_EXISTE` | ID de cliente duplicado |
| `E_ID_CLIENTE_NO_EXISTE` | Cliente no encontrado |
| `E_SNACK_NO_DISPONIBLE` | Snack no existe o stock insuficiente |
| `E_CANTIDAD_INVALIDA` | Cantidad debe ser mayor a 0 |

---

## 🔐 Características de Seguridad

- **IDs únicos:** Previene duplicación de vendedores/clientes
- **Validación de existencia:** Verifica que vendedores/clientes existan antes de operar
- **Control de stock:** No permite ventas sin inventario suficiente
- **Validación de cantidad:** Rechaza cantidades inválidas (≤ 0)
- **Historial inmutable:** Las compras se registran permanentemente

---

## 📈 Métricas Rastreadas

- Ventas totales por vendedor (unidades)
- Compras totales por cliente (unidades)
- Historial completo de compras por cliente
- Inventario en tiempo real por tipo de snack y vendedor
- Niveles de lealtad automáticos

---

## 📝 Nota

Este contrato está diseñado para la blockchain Sui y utiliza el framework Move. El sistema de lealtad promueve la retención de clientes mediante incentivos progresivos basados en volumen de compras.
