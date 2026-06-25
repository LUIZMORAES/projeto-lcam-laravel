import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuthStore } from '../stores/authStore'
import './DashboardPage.css'

function DashboardPage() {
  const { user, logout } = useAuthStore()
  const navigate = useNavigate()

  const handleLogout = async () => {
    await logout()
    navigate('/login')
  }

  return (
    <div className="dashboard-page">
      <nav className="dashboard-header">
        <div className="header-content">
          <h1 className="header-logo">LCAM</h1>
          <button className="btn-logout" onClick={handleLogout}>
            Sair
          </button>
        </div>
      </nav>

      <main className="dashboard-main">
        <div className="dashboard-container">
          <div className="welcome-section">
            <h2>Bem-vindo!</h2>
            <p className="welcome-text">{user?.name}</p>
          </div>

          <div className="user-info-card">
            <h3>Informações da Conta</h3>
            <div className="info-grid">
              <div className="info-item">
                <label>Nome</label>
                <p>{user?.name}</p>
              </div>
              <div className="info-item">
                <label>Email</label>
                <p>{user?.email}</p>
              </div>
              <div className="info-item">
                <label>CPF</label>
                <p>{user?.cpf}</p>
              </div>
              <div className="info-item">
                <label>Telefone</label>
                <p>{user?.phone}</p>
              </div>
              <div className="info-item">
                <label>Status</label>
                <p className="status-active">{user?.status === 'active' ? 'Ativo' : 'Inativo'}</p>
              </div>
              <div className="info-item">
                <label>Membro desde</label>
                <p>{new Date(user?.created_at).toLocaleDateString('pt-BR')}</p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}

export default DashboardPage
