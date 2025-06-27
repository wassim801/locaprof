import { useState } from 'react';
import {
  Card,
  CardHeader,
  CardBody,
  Typography,
  Button,
  IconButton,
  Tooltip,
  Input,
  Spinner,
} from '@material-tailwind/react';
import {
  MagnifyingGlassIcon,
  ChevronUpDownIcon,
  EyeIcon,
  CalendarDaysIcon,
  XMarkIcon,
} from '@heroicons/react/24/outline';

const TABLE_HEAD = [
  { id: 'property', label: 'Propriété' },
  { id: 'tenant', label: 'Locataire' },
  { id: 'owner', label: 'Propriétaire' },
  { id: 'dates', label: 'Dates' },
  { id: 'status', label: 'Statut' },
  { id: 'actions', label: '' },
];

// Données de test en attendant l'intégration de l'API
const TABLE_ROWS = [
  {
    id: '1',
    property: 'Appartement moderne',
    tenant: 'Marie Martin',
    owner: 'Jean Dupont',
    startDate: '2024-02-01',
    endDate: '2024-02-15',
    status: 'confirmé',
  },
  // Ajouter plus de données de test
];

export default function BookingsPage() {
  const [searchQuery, setSearchQuery] = useState('');

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('fr-FR');
  };

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-gray-900">Réservations</h2>
          <p className="mt-1 text-sm text-gray-600">
            Gérez les réservations de la plateforme
          </p>
        </div>
        <Button className="flex items-center gap-2" size="sm" color="blue">
          <CalendarDaysIcon className="h-4 w-4" />
          Nouvelle réservation
        </Button>
      </div>

      <Card>
        <CardHeader floated={false} shadow={false} className="rounded-none">
          <div className="mb-4 flex items-center justify-between gap-8">
            <div className="flex items-center gap-2">
              <Input
                label="Rechercher"
                icon={<MagnifyingGlassIcon className="h-5 w-5" />}
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
            </div>
          </div>
        </CardHeader>
        <CardBody className="overflow-x-scroll px-0">
          <table className="w-full min-w-max table-auto text-left">
            <thead>
              <tr>
                {TABLE_HEAD.map((head) => (
                  <th
                    key={head.id}
                    className="border-b border-blue-gray-100 bg-blue-gray-50 p-4"
                  >
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal leading-none opacity-70"
                    >
                      {head.label}
                      {head.id !== 'actions' && (
                        <ChevronUpDownIcon
                          strokeWidth={2}
                          className="ml-2 h-4 w-4 inline-block cursor-pointer"
                        />
                      )}
                    </Typography>
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {TABLE_ROWS.map((booking) => (
                <tr key={booking.id}>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {booking.property}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {booking.tenant}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {booking.owner}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {`${formatDate(booking.startDate)} - ${formatDate(booking.endDate)}`}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <div className="w-max">
                      <Typography
                        variant="small"
                        className={`rounded-md px-2 py-1 font-medium ${
                          booking.status === 'confirmé'
                            ? 'bg-green-50 text-green-600'
                            : booking.status === 'en attente'
                            ? 'bg-orange-50 text-orange-600'
                            : 'bg-red-50 text-red-600'
                        }`}
                      >
                        {booking.status}
                      </Typography>
                    </div>
                  </td>
                  <td className="p-4">
                    <div className="flex gap-2">
                      <Tooltip content="Voir les détails">
                        <IconButton variant="text" color="blue-gray">
                          <EyeIcon className="h-4 w-4" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip content="Annuler">
                        <IconButton variant="text" color="red">
                          <XMarkIcon className="h-4 w-4" />
                        </IconButton>
                      </Tooltip>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </CardBody>
      </Card>
    </div>
  );
}