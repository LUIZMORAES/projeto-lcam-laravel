<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class UserController extends Controller
{
    /**
     * Obter dados do usuário autenticado
     */
    public function getCurrentUser(Request $request)
    {
        try {
            return response()->json([
                'user' => $request->user(),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erro ao obter dados do usuário',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Atualizar perfil do usuário
     */
    public function updateProfile(Request $request)
    {
        try {
            $user = $request->user();

            $validated = $request->validate([
                'name' => 'sometimes|string|min:3|max:255',
                'phone' => 'sometimes|string|min:10|max:20',
                'email' => 'sometimes|email|unique:users,email,' . $user->id,
            ], [
                'name.min' => 'Nome deve ter pelo menos 3 caracteres',
                'phone.min' => 'Telefone inválido',
                'email.email' => 'Email inválido',
                'email.unique' => 'Este email já está registrado',
            ]);

            $user->update($validated);

            return response()->json([
                'message' => 'Perfil atualizado com sucesso',
                'user' => $user,
            ], 200);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Erro de validação',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Erro ao atualizar perfil',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
