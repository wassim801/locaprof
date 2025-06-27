import { useState } from 'react';
import {
  Typography,
  Input,
  Button,
  Card,
  CardBody,
} from '@material-tailwind/react';

export default function ProfilePage() {
  const [formData, setFormData] = useState({
    fullName: 'Wassim Nasr',
    email: 'wassim@example.com',
    phone: '+216 123 456 789',
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData(prev => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    alert('Profil mis à jour !');
    // TODO: Save to API
  };

  return (
    <main className="max-w-4xl mx-auto p-6 bg-white rounded shadow">
      <Typography variant="h4" className="mb-6 font-bold text-blue-gray-900">
        Mon Profil
      </Typography>

      <Card>
        <CardBody>
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <Typography
                variant="small"
                className="block mb-1 font-medium text-blue-gray-700"
              >
                Nom complet
              </Typography>
              <Input
                size="lg"
                type="text"
                name="fullName"
                value={formData.fullName}
                onChange={handleChange}
                required
              />
            </div>

            <div>
              <Typography
                variant="small"
                className="block mb-1 font-medium text-blue-gray-700"
              >
                Email
              </Typography>
              <Input
                size="lg"
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                required
              />
            </div>

            <div>
              <Typography
                variant="small"
                className="block mb-1 font-medium text-blue-gray-700"
              >
                Téléphone
              </Typography>
              <Input
                size="lg"
                type="tel"
                name="phone"
                value={formData.phone}
                onChange={handleChange}
              />
            </div>

            <Button
              type="submit"
              size="lg"
              className="w-full bg-indigo-600 hover:bg-indigo-700 active:bg-indigo-800 shadow-lg uppercase tracking-wide font-semibold transition duration-300"
            >
              Mettre à jour
            </Button>
          </form>
        </CardBody>
      </Card>
    </main>
  );
}
