import { create } from 'zustand'
import api from '../services/api'

const useAuthStore = create((set) => ({
  user: null,
  token: localStorage.getItem('authToken') || null,
  isAuthenticated: !!localStorage.getItem('authToken'),
  isLoading: false,
  error: null,

  setError: (error) => set({ error }),
  clearError: () => set({ error: null }),

  // Login
  login: async (email, password) => {
    set({ isLoading: true, error: null })
    try {
      const response = await api.post('/login', { email, password })
      const { token, user } = response.data

      localStorage.setItem('authToken', token)
      set({
        user,
        token,
        isAuthenticated: true,
        isLoading: false,
      })
      return { success: true }
    } catch (error) {
      const errorMsg = error.response?.data?.message || 'Erro ao fazer login'
      set({
        error: errorMsg,
        isLoading: false,
      })
      return { success: false, error: errorMsg }
    }
  },

  // Register
  register: async (userData) => {
    set({ isLoading: true, error: null })
    try {
      const response = await api.post('/register', userData)
      const { token, user } = response.data

      localStorage.setItem('authToken', token)
      set({
        user,
        token,
        isAuthenticated: true,
        isLoading: false,
      })
      return { success: true }
    } catch (error) {
      const errorMsg = error.response?.data?.message || 'Erro ao registrar'
      set({
        error: errorMsg,
        isLoading: false,
      })
      return { success: false, error: errorMsg }
    }
  },

  // Logout
  logout: async () => {
    set({ isLoading: true })
    try {
      await api.post('/logout')
      localStorage.removeItem('authToken')
      set({
        user: null,
        token: null,
        isAuthenticated: false,
        isLoading: false,
        error: null,
      })
      return { success: true }
    } catch (error) {
      const errorMsg = error.response?.data?.message || 'Erro ao fazer logout'
      set({
        error: errorMsg,
        isLoading: false,
      })
      return { success: false, error: errorMsg }
    }
  },

  // Get Current User
  getCurrentUser: async () => {
    try {
      const response = await api.get('/me')
      set({ user: response.data.user })
      return { success: true }
    } catch (error) {
      return { success: false, error: error.message }
    }
  },

  // Update Profile
  updateProfile: async (userData) => {
    set({ isLoading: true, error: null })
    try {
      const response = await api.put('/profile', userData)
      set({
        user: response.data.user,
        isLoading: false,
      })
      return { success: true }
    } catch (error) {
      const errorMsg = error.response?.data?.message || 'Erro ao atualizar perfil'
      set({
        error: errorMsg,
        isLoading: false,
      })
      return { success: false, error: errorMsg }
    }
  },
}))

export { useAuthStore }
