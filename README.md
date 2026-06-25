# Projeto LCAM - Sistema de Login React + Laravel

Sistema de login com design inspirado no Banco C6, desenvolvido com **React** (Frontend) e **Laravel** (Backend) com autenticação via **Laravel Sanctum**.

## 🎯 Características

- ✅ Login com credenciais (CPF, Email)
- ✅ Pré-cadastro em modal
- ✅ Autenticação via Laravel Sanctum
- ✅ Design escuro moderno (inspirado C6)
- ✅ Database MySQL/MariaDB
- ✅ Validações robustas (Backend + Frontend)
- ✅ Responsivo para mobile/desktop

## 📋 Requisitos

### Backend
- PHP 8.3.19+
- Laravel 11+
- MySQL 5.2.2+ / MariaDB
- Composer

### Frontend
- Node.js v24.13.1+
- React 18+
- Vite

## 🚀 Instalação Rápida

### 1. Backend (Laravel)

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate

# Configurar database no .env
php artisan migrate
php artisan serve
```

### 2. Frontend (React)

```bash
cd frontend
npm install
npm run dev
```

## 🗄️ Database Setup

### Opção 1: Via phpMyAdmin
1. Acesse phpMyAdmin
2. Crie um novo banco: `lcam_db`
3. Importe `database/migrations.sql`

### Opção 2: Via CLI MySQL
```bash
mysql -u root -p < database/migrations.sql
```

## 📁 Estrutura do Projeto

```
projeto-lcam-laravel/
├── backend/                    # Laravel API
│   ├── app/
│   │   ├── Http/Controllers/
│   │   │   ├── AuthController.php
│   │   │   └── UserController.php
│   │   ├── Models/User.php
│   │   └── Services/AuthService.php
│   ├── routes/api.php
│   ├── database/migrations/
│   ├── config/
│   ├── .env.example
│   └── composer.json
├── frontend/                   # React + Vite
│   ├── src/
│   │   ├── components/
│   │   │   ├── LoginForm.jsx
│   │   │   ├── PreRegisterModal.jsx
│   │   │   └── Dashboard.jsx
│   │   ├── pages/
│   │   ├── services/api.js
│   │   ├── styles/
│   │   └── App.jsx
│   ├── vite.config.js
│   └── package.json
├── database/
│   └── migrations.sql
└── README.md
```

## 🔐 Autenticação (Sanctum)

| Método | Rota | Descrição |
|--------|------|----------|
| POST | `/api/register` | Pré-cadastro |
| POST | `/api/login` | Login |
| POST | `/api/logout` | Logout (requer autenticação) |
| GET | `/api/me` | Dados do usuário |
| PUT | `/api/profile` | Atualizar perfil |

## 📝 Credenciais do Usuário (Database)

| Campo | Tipo | Validação |
|-------|------|----------|
| `name` | VARCHAR(255) | Obrigatório |
| `cpf` | VARCHAR(14) | Único, formato: XXX.XXX.XXX-XX |
| `email` | VARCHAR(255) | Único, válido |
| `phone` | VARCHAR(20) | Obrigatório |
| `password` | VARCHAR(255) | Min 8 caracteres (bcrypt) |
| `status` | ENUM('active','inactive') | Padrão: active |
| `created_at` | TIMESTAMP | Auto |
| `updated_at` | TIMESTAMP | Auto |

## 🎨 Design

- **Tema**: Escuro (inspirado Banco C6)
- **Cores principais**: 
  - Preto: `#000000` / `#0a0a0a`
  - Azul: `#0066cc` / `#0052a3`
  - Cinza: `#666666` / `#999999`
- **Responsivo**: Mobile-first approach

## 🛠️ Desenvolvimento Local

### Terminal 1 - Backend
```bash
cd backend
php artisan serve
```

### Terminal 2 - Frontend
```bash
cd frontend
npm run dev
```

**URL da aplicação**: http://localhost:5173

## 📚 Variáveis de Ambiente

### Backend (`.env`)
```env
APP_NAME="LCAM Login"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=lcam_db
DB_USERNAME=root
DB_PASSWORD=

SANCTUM_STATEFUL_DOMAINS=localhost:5173
SESSION_DOMAIN=localhost
```

### Frontend (`.env.local`)
```env
VITE_API_URL=http://localhost:8000/api
```

## 🚀 Build para Produção

### Backend
```bash
cd backend
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Frontend
```bash
cd frontend
npm run build
# Resultado em: dist/
```

## 🐛 Troubleshooting

### CORS Error
- Verifique `SANCTUM_STATEFUL_DOMAINS` no `.env` do backend

### Database Connection
- Confirme credenciais no `.env`
- Verifique se MySQL está rodando

### Frontend não conecta API
- Verifique se `VITE_API_URL` está correto
- Verifique se Laravel está rodando em `http://localhost:8000`

## 📞 Suporte

Para dúvidas ou problemas, abra uma **Issue** no repositório.

---

**Desenvolvido por:** LCAM  
**Versões:** PHP 8.3.19 | Node.js v24.13.1 | Laravel 11 | React 18 | MySQL 5.2.2  
**Data:** 2026-06-25