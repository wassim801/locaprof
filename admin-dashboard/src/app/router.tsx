import { createBrowserRouter, Navigate } from 'react-router-dom';
import DashboardLayout from '../components/layout/DashboardLayout';
import DashboardPage from '../features/dashboard/DashboardPage';
import PrivateRoute from '../features/auth/PrivateRoute';
import React from 'react';
import ProfilePage from '../features/profile/ProfilePage';
import SettingsPage from '../features/profile/SettingsPage';

// Lazy loading des autres pages
const UsersPage = React.lazy(() => import('../features/users/UsersPage'));
const PropertiesPage = React.lazy(() => import('../features/properties/PropertiesPage'));
const BookingsPage = React.lazy(() => import('../features/bookings/BookingsPage'));
const MessagesPage = React.lazy(() => import('../features/messages/MessagesPage'));
const StatsPage = React.lazy(() => import('../features/stats/StatsPage'));
const LoginPage = React.lazy(() => import('../features/auth/LoginPage'));

// Wrap component with PrivateRoute and Suspense
const ProtectedSuspense = ({ children }: { children: React.ReactNode }) => (
  <PrivateRoute>
    <Suspense>{children}</Suspense>
  </PrivateRoute>
);

// HOC pour le chargement asynchrone
const Suspense = ({ children }: { children: React.ReactNode }) => (
  <React.Suspense
    fallback={
      <div className="flex h-screen items-center justify-center">
        <div className="h-16 w-16 animate-spin rounded-full border-4 border-primary-600 border-t-transparent" />
      </div>
    }
  >
    {children}
  </React.Suspense>
);

export const router = createBrowserRouter([
  {
    path: '/login',
    element: (
      <Suspense>
        <LoginPage />
      </Suspense>
    ),
  },
  {
    path: '/',
    element: (
      <PrivateRoute>
        <DashboardLayout />
      </PrivateRoute>
    ),
    children: [
      {
        index: true,
        element: <DashboardPage />,
      },
      {
        path: 'users',
        element: (
          <ProtectedSuspense>
            <UsersPage />
          </ProtectedSuspense>
        ),
      },
      {
        path: 'properties',
        element: (
          <ProtectedSuspense>
            <PropertiesPage />
          </ProtectedSuspense>
        ),
      },
      {
        path: 'profile',
        element: (
          <ProtectedSuspense>
            <ProfilePage />
          </ProtectedSuspense>
        ),
      },
      {
        path: 'settings',
        element: (
          <ProtectedSuspense>
            <SettingsPage />
          </ProtectedSuspense>
        ),
      },
      {
        path: 'bookings',
        element: (
          <ProtectedSuspense>
            <BookingsPage />
          </ProtectedSuspense>
        ),
      },
      {
        path: 'messages',
        element: (
          <Suspense>
            <MessagesPage />
          </Suspense>
        ),
      },
      {
        path: 'stats',
        element: (
          <Suspense>
            <StatsPage />
          </Suspense>
        ),
      },
    ],
  },
]);