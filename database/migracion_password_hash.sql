-- Migración: Convertir contraseñas en texto plano a SHA-256 con salt
-- Requiere PostgreSQL 15+ (sha256 incorporado) o pgcrypto
-- El salt usado en Java es "SICE2026" (ver util.PasswordUtil)
-- 
-- Ejecutar SOLO si ya hay usuarios con contraseñas en texto plano.
-- En adelante, el DAO las guarda automáticamente hasheadas.
-- El primer login también migra automáticamente (rehash on login).

-- Opción 1: PostgreSQL 15+ con sha256() nativo
UPDATE usuario SET password = encode(sha256(convert_to('SICE2026' || password, 'UTF8')), 'hex');

-- Opción 2: si no funciona, usar pgcrypto
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- UPDATE usuario SET password = encode(digest('SICE2026' || password, 'sha256'), 'hex');

-- Verificar (debe mostrar hashes de 64 caracteres hex)
-- SELECT id, username, length(password), password FROM usuario;
