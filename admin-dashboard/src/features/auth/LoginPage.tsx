import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Card,
  CardHeader,
  CardBody,
  CardFooter,
  Input,
  Button,
  Typography,
  Alert,
} from '@material-tailwind/react';
import { useLoginMutation } from './authApi';
import { useAppDispatch } from '../../app/hooks';
import { setCredentials } from './authSlice';

export default function LoginPage() {
  const navigate = useNavigate();
  const dispatch = useAppDispatch();
  const [login, { isLoading }] = useLoginMutation();

  const [formData, setFormData] = useState({
    email: '',
    password: '',
  });
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    try {
      const result = await login(formData).unwrap();
      if (result.success && result.user.role == 'admin') {
        dispatch(setCredentials({ user: result.user, token: result.token }));
        navigate('/');
      } else {
        setError('Accès non autorisé. Seuls les administrateurs peuvent se connecter.');
      }
    } catch (err) {
      setError(
        (err as any)?.data?.message ||
        'Une erreur est survenue lors de la connexion. Veuillez réessayer.'
      );

    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-blue-50 to-blue-100 px-4 py-12 sm:px-6 lg:px-8">
      <Card className="w-full max-w-md shadow-xl">
        <CardHeader
          variant="gradient"
          color="blue"
          className="mb-4 grid h-28 place-items-center bg-gradient-to-r from-blue-600 to-blue-400">
          <Typography variant="h3" color="white" className="font-bold text-3xl">
            LocaPro Admin
          </Typography>
        </CardHeader>

        <CardBody className="flex flex-col gap-6 px-6">
          {error && (
            <Alert color="red" variant="gradient" className="mb-4 font-medium">
              {error}
            </Alert>
          )}

          <form onSubmit={handleSubmit} className="mt-4 space-y-8">
            <div className="space-y-6">
              <Input
                type="email"
                label="Email"
                size="lg"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                className="!border-t-blue-gray-200 focus:!border-blue-500"
              autoComplete="current-password"
              autoComplete="email"
                labelProps={{
                  className: "!text-blue-gray-500",
                }}
                required
              />

              <Input
                type="password"
                label="Mot de passe"
                size="lg"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                className="!border-t-blue-gray-200 focus:!border-blue-500"
                labelProps={{
                  className: "!text-blue-gray-500",
                }}
                required
              />
            </div>

            <CardFooter className="pt-0 px-0">
              <Button
                variant="gradient"
                fullWidth
                type="submit"
                disabled={isLoading}
                className="bg-gradient-to-r from-blue-600 to-blue-400 shadow-lg hover:shadow-blue-500/40 transition-all duration-300"
              >
                {isLoading ? 'Connexion...' : 'Se connecter'}
              </Button>
            </CardFooter>
          </form>
        </CardBody>
      </Card>
    </div>
  );
}