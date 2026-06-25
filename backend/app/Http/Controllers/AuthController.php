<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Registrar novo usuário (Pré-cadastro)
     */
    public function register(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|min:3|max:255',
                'cpf' => 'required|string|unique:users,cpf|regex:/^\d{3}\.\d{3}\.\d{3}-\d{2}$/',
                'email' => 'required|email|unique:users,email',
                'phone' => 'required|string|min:10|max:20',
                'password' => 'required|string|min:8|confirmed',
            ], [
                'name.required' => 'Nome é obrigatório',
                'name.min' => 'Nome deve ter pelo menos 3 caracteres',
                'cpf.required' => 'CPF é obrigatório',
                'cpf.unique' => 'Este CPF já está registrado',
                'cpf.regex' => 'CPF inválido. Formato: XXX.XXX.XXX-XX',
                'email.required' => 'Email é obrigatório',
                'email.email' => 'Email inválido',
                'email.unique' => 'Este email já está registrado',
                'phone.required' => 'Telefone é obrigatório',
                'password.required' => 'Senha é obrigatória',
                'password.min' => 'Senha deve ter pelo menos 8 caracteres',
                'password.confirmed' => 'As senhas não coincidem',
            ]);

            $user = User::create([
                'name' => $validated['name'],
                'cpf' => $validated['cpf'],
                'email' => $validated['email'],
                'phone' => $validated['phone'],
                'password' => $validated['password'],
                'status' => 'active',
            ]);

            return response()->json([
                'message' => 'Usuário registrado com sucesso',
                'user' => $user,
                'token' => $user->createToken('auth_token')->plainTextToken,
            ], 201);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erro ao registrar usuário',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Login do usuário
     */
    public function login(Request $request)
    {
        try {
            $validated = $request->validate([
                'email' => 'required|email',
                'password' => 'required|string',
            ], [
                'email.required' => 'Email é obrigatório',
                'email.email' => 'Email inválido',
                'password.required' => 'Senha é obrigatória',
            ]);

            $user = User::where('email', $validated['email'])->first();

            if (!$user || !Hash::check($validated['password'], $user->password)) {
                throw ValidationException::withMessages([
                    'email' => 'As credenciais fornecidas estão incorretas.',
                ]);
            }

            if (!$user->isActive()) {
                return response()->json([
                    'message' => 'Usuário inativo',
                ], 403);
            }

            // Revogar tokens anteriores
            $user->tokens()->delete();

            return response()->json([
                'message' => 'Login realizado com sucesso',
                'user' => $user,
                'token' => $user->createToken('auth_token')->plainTextToken,
            ], 200);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erro ao fazer login',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Logout do usuário
     */
    public function logout(Request $request)
    {
        try {
            $request->user()->currentAccessToken()->delete();

            return response()->json([
                'message' => 'Logout realizado com sucesso',
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erro ao fazer logout',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
