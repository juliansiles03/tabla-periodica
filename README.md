# Periodic Table
## Project notes
- Enforced NOT NULL y UNIQUE en elements (name, symbol).
- Normalicé `type` a tabla `types` y agregué `type_id` como FK en `properties`.
- Renombré columnas: weight->atomic_mass, melting_point->melting_point_celsius, boiling_point->boiling_point_celsius.
- `atomic_mass` pasado a DECIMAL y sin ceros a la derecha.
- Agregados F (9) y Ne (10) con sus propiedades (nonmetal).
- Script: `./element.sh <atomic_number|symbol|name>`
  - Ejemplos: `./element.sh 1`, `./element.sh H`, `./element.sh Hydrogen`
