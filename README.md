# EAFITShop – Performance Engineering en PostgreSQL

Proyecto desarrollado para la materia **Bases de Datos Avanzadas – EAFIT**.

Este repositorio contiene la implementación completa del laboratorio de optimización y performance engineering aplicado sobre PostgreSQL en un entorno Big Data simulado tipo e-commerce.

---

## Integrantes

- Daniel Arcila  
- Juan Simón Ospina  
- Sebastián Durán  
---

## Objetivo del Proyecto

Diagnosticar y optimizar el rendimiento de PostgreSQL aplicando técnicas reales de ingeniería de performance:

- Indexación estratégica  
- Particionamiento por rango  
- Reescritura de queries  
- Control de concurrencia  
- Performance tuning (memoria y planner)  
- Análisis comparativo con `EXPLAIN (ANALYZE, BUFFERS)`  

Todas las optimizaciones fueron validadas empíricamente con métricas reales.

---

## Arquitectura del Proyecto

- **Infraestructura:** AWS EC2 t2.large
- **Conección:** AWS RDS
- **Motor:** PostgreSQL en contenedor Docker  
- **Dataset:** millones de registros  

**Herramientas:**

- `EXPLAIN (ANALYZE, BUFFERS)`  
- `pg_stat_activity`  
- `pg_settings`  

---

## Estructura del Repositorio

```
PROYECTO_1/
│
├── Scripts_base/
│   ├── 01_schema.sql
│   ├── 03_generate_big.sql
│   ├── 04_queries_base.sql
│   └── 05_optimizacion_base.sql
│
├── Optimizacion_concurrencia/
│   ├── Preparacion.sql
│   ├── Concurrencia_1.sql
│   ├── Concurrencia_2.sql
│   └── medicion.sql
│
├── Optimizacion_indices/
│   └── Optimizacion_indices.sql
│
├── Optimizacion_particionamiento/
│   └── Optimizacion_particionamiento.sql
│
├── Optimizacion_reescritura/
│   ├── Query_5.sql
│   └── Query_6.sql
│
├── Performance_tunning/
│   ├── parametros_antes.sql
│   └── tunning_rapido.sql
│
└── informe DB 2.pdf
```

---

## Requisitos para Replicación

### 1️ Requisitos Técnicos

- Docker  
- Docker Compose  
- PostgreSQL 16+  
- 8 GB RAM recomendados  
- 20 GB almacenamiento mínimo  

---

### 2️ Levantar PostgreSQL en Docker

Ejemplo de `docker-compose`:

```yaml
version: "3.9"

services:
  postgres:
    image: postgres:18.1
    container_name: pg_lab_postgres
    restart: unless-stopped
    shm_size: "1gb"

    environment:
      POSTGRES_DB: eafitshop
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres

    ports:
      - "5432:5432"

    volumes:
      - pg_data:/var/lib/postgresql/data

volumes:
  pg_data:

```
Luego ejecutar:

```bash
docker compose up -d
```

## Pasos para Ejecutar el Proyecto

### Paso 1 – Crear esquema
`01_schema.sql`

### Paso 2 – Generar Big Data
`03_generate_big.sql`

### Paso 3 – Ejecutar Queries Baseline
`04_queries_base.sql`

Medir con:

```sql
EXPLAIN (ANALYZE, BUFFERS)
```

Guardar métricas.

---

# Optimización Aplicada

## 1. Índices

Resultados principales (según informe **informe DB 2**):

- Q1: ↓46%
- Q3: ↓99.996%
- Q6: ↓31%

---

## 2. Particionamiento por rango

Se particionó `orders` por año.

Se validó *partition pruning* en consultas con filtro temporal.

---

## 3. Reescritura de Queries

Eliminación de `date_trunc()` para volver condición sargable.

Resultado:

```
1281 ms → 457 ms (~2.8x más rápido)
```

---

## 4. Concurrencia

### Baseline

- Race condition
- Error 23505 (duplicate key)
- Transacciones abortadas

### Optimización

`FOR UPDATE`

y

`FOR UPDATE SKIP LOCKED`

### Resultados

- Consistencia garantizada
- Eliminación de errores
- Mayor throughput sin contención

---

## 5. Performance Tuning

Parámetros ajustados:

```sql
SET work_mem = '64MB';
SET effective_cache_size = '6GB';
```

Mejoras observadas:

- Q1: +7.69%
- Q3: +20.91%
- Q6: +10.92%

El tuning mejora decisiones del planner pero no reemplaza rediseño estructural.

---

# Resultados Globales

El proyecto demuestra que:

- La indexación estratégica reduce drásticamente I/O.
- El particionamiento mejora consultas temporales.
- La reescritura mejora sargabilidad.
- El control de concurrencia elimina condiciones de carrera.
- El tuning mejora el planner pero tiene impacto limitado comparado con rediseño físico.

---

# Buenas Prácticas Aplicadas (DevOps)

- Scripts versionados por tipo de optimización.
- Separación clara de baseline vs optimizado.
- Métricas reproducibles con `EXPLAIN ANALYZE`.
- Infraestructura containerizada.
- Código SQL modular.
- Proyecto reproducible desde cero.

---

# Líneas Futuras

- Persistir parámetros en `postgresql.conf`
- Ajustar `shared_buffers`
- Evaluar `random_page_cost`
- Pruebas de carga concurrente automatizadas
- Materialized views

---

# Uso de ChatGPT

ChatGPT fue utilizado como herramienta de apoyo conceptual y estructural.  
Todas las mediciones y validaciones fueron realizadas directamente en PostgreSQL.

**informe DB 2**

---

# Conclusión

La optimización en PostgreSQL requiere un enfoque integral que combine:

- Diseño físico
- Indexación
- Sargabilidad
- Control de concurrencia
- Ajustes del planner

Este proyecto reproduce escenarios reales de plataformas e-commerce de alto volumen.
