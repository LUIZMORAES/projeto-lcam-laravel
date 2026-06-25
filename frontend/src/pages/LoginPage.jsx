import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import LoginForm from '../components/LoginForm'
import PreRegisterModal from '../components/PreRegisterModal'
import './LoginPage.css'

function LoginPage() {
  const [showRegisterModal, setShowRegisterModal] = useState(false)
  const navigate = useNavigate()

  const handleLoginSuccess = () => {
    navigate('/dashboard')
  }

  return (
    <div className="login-page">
      <div className="login-container">
        <div className="login-header">
          <h1 className="login-logo">LCAM</h1>
          <p className="login-subtitle">Acesso Seguro</p>
        </div>

        <LoginForm onSuccess={handleLoginSuccess} />

        <div className="login-footer">
          <p className="login-text">
            Não tem conta?{' '}
            <button
              className="btn-register-link"
              onClick={() => setShowRegisterModal(true)}
            >
              Crie uma agora
            </button>
          </p>
        </div>
      </div>

      {showRegisterModal && (
        <PreRegisterModal
          onClose={() => setShowRegisterModal(false)}
          onSuccess={handleLoginSuccess}
        />
      )}
    </div>
  )
}

export default LoginPage
