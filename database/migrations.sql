-- =====================================================
-- LCAM Login System - Database Schema
-- Database: lcam_db
-- MySQL Version: 5.2.2+
-- =====================================================

-- Criar Database
CREATE DATABASE IF NOT EXISTS `lcam_db`;
USE `lcam_db`;

-- =====================================================
-- Tabela: users
-- Descrição: Armazena dados dos usuários
-- =====================================================
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nome completo do usuário',
  `cpf` varchar(14) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE COMMENT 'CPF formatado (XXX.XXX.XXX-XX)',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE COMMENT 'Email único',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Telefone com DDD',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Senha criptografada (bcrypt)',
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active' COMMENT 'Status da conta',
  `email_verified_at` timestamp NULL DEFAULT NULL COMMENT 'Data de verificação do email',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  
  KEY `idx_email` (`email`),
  KEY `idx_cpf` (`cpf`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabela de usuários do sistema';

-- =====================================================
-- Tabela: personal_access_tokens
-- Descrição: Tokens Sanctum para autenticação API
-- =====================================================
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `abilities` longtext COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tokens de acesso pessoal (Sanctum)';

-- =====================================================
-- Dados de Teste (Opcional)
-- =====================================================

-- Usuário de teste (senha: password123)
INSERT INTO `users` (`name`, `cpf`, `email`, `phone`, `password`, `status`, `created_at`) VALUES
('João Silva', '123.456.789-10', 'joao@example.com', '11987654321', '$2y$10$5R7p7p7p7p7p7p7p7p7p7Z5K8K8K8K8K8K8K8K8K8K8K8K8K8K8K8', 'active', NOW()),
('Maria Santos', '987.654.321-00', 'maria@example.com', '11912345678', '$2y$10$5R7p7p7p7p7p7p7p7p7p7Z5K8K8K8K8K8K8K8K8K8K8K8K8K8K8K8', 'active', NOW());

-- =====================================================
-- Views
-- =====================================================

-- View: vw_users_active
CREATE OR REPLACE VIEW `vw_users_active` AS
SELECT 
  id,
  name,
  cpf,
  email,
  phone,
  status,
  created_at,
  updated_at
FROM `users`
WHERE `status` = 'active';

-- =====================================================
-- Stored Procedures
-- =====================================================

-- Procedure: sp_get_user_by_email
DELIMITER $$
CREATE PROCEDURE `sp_get_user_by_email`(IN p_email VARCHAR(255))
READS SQL DATA
BEGIN
  SELECT id, name, cpf, email, phone, status, created_at, updated_at
  FROM `users`
  WHERE email = p_email;
END$$
DELIMITER ;

-- Procedure: sp_get_user_by_cpf
DELIMITER $$
CREATE PROCEDURE `sp_get_user_by_cpf`(IN p_cpf VARCHAR(14))
READS SQL DATA
BEGIN
  SELECT id, name, cpf, email, phone, status, created_at, updated_at
  FROM `users`
  WHERE cpf = p_cpf;
END$$
DELIMITER ;

-- Procedure: sp_deactivate_user
DELIMITER $$
CREATE PROCEDURE `sp_deactivate_user`(IN p_user_id BIGINT)
MODIFIES SQL DATA
BEGIN
  UPDATE `users` SET `status` = 'inactive' WHERE id = p_user_id;
END$$
DELIMITER ;

-- =====================================================
-- Índices adicionais para performance
-- =====================================================
CREATE INDEX idx_users_email_status ON `users` (`email`, `status`);
CREATE INDEX idx_users_cpf_status ON `users` (`cpf`, `status`);

-- =====================================================
-- Fin do script
-- =====================================================
