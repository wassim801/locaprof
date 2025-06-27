import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react';

interface LoginRequest {
  email: string;
  password: string;
}

interface User {
  id: string;
  email: string;
  role: string;
  nom: string;
  prenom: string;
}

interface AuthResponse {
  success: boolean;
  token: string;
  user: User;
}

export const authApi = createApi({
  reducerPath: 'authApi',
  baseQuery: fetchBaseQuery({
    baseUrl: 'http://localhost:5000/api',
    prepareHeaders: (headers, { getState }) => {
      // Get token from storage (consider using more secure storage)
      const token = localStorage.getItem('token');
      
      // If we have a token, set the authorization header
      if (token) {
        headers.set('Authorization', `Bearer ${token}`);
      }
      
      // Important: Set content-type for all requests
      headers.set('Content-Type', 'application/json');
      return headers;
    },
    // Add credentials if using cookies
    credentials: 'include',
  }),
  endpoints: (builder) => ({
    login: builder.mutation<AuthResponse, LoginRequest>({
      query: (credentials) => ({
        url: '/auth/login',
        method: 'POST',
        body: credentials,
      }),
      transformResponse: (response: AuthResponse) => {
        // Store token only if it exists in response
        if (response.token) {
          localStorage.setItem('token', response.token);
        }
        return response;
      },
      transformErrorResponse: (response: { status: number, data: any }) => {
        // Handle 401 specifically if needed
        if (response.status === 401) {
          return { 
            ...response, 
            message: response.data?.message || 'Invalid credentials' 
          };
        }
        return response;
      }
    }),
    // Add other auth-related endpoints
    logout: builder.mutation<void, void>({
      query: () => ({
        url: '/auth/logout',
        method: 'POST',
      }),
      transformResponse: () => {
        localStorage.removeItem('token');
      }
    }),
  }),
});

export const { 
  useLoginMutation,
  useLogoutMutation,
  useGetMeQuery,
} = authApi;