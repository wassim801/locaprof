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
  PencilIcon,
  HomeModernIcon,
  TrashIcon,
} from '@heroicons/react/24/outline';

const TABLE_HEAD = [
  { id: 'title', label: 'Titre' },
  { id: 'type', label: 'Type' },
  { id: 'owner', label: 'Propriétaire' },
  { id: 'address', label: 'Adresse' },
  { id: 'status', label: 'Statut' },
  { id: 'actions', label: '' },
];

// Données de test en attendant l'intégration de l'API
const TABLE_ROWS = [
  {
    id: '1',
    title: 'Appartement moderne',
    type: 'Appartement',
    owner: 'Jean Dupont',
    address: '123 rue de Paris, 75001 Paris',
    status: 'disponible',
  },
  // Ajouter plus de données de test
];

export default function PropertiesPage() {
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8 space-y-8">
      <div className="flex items-center justify-between bg-white rounded-xl p-6 shadow-sm">
        <div>
          <h2 className="text-3xl font-bold text-gray-900 tracking-tight">Propriétés</h2>
          <p className="mt-2 text-sm text-gray-600">
            Gérez les propriétés de la plateforme
          </p>
        </div>
        <Button className="flex items-center gap-2 bg-blue-500 hover:bg-blue-600 transition-colors" size="sm">
          <HomeModernIcon className="h-4 w-4" />
          Ajouter une propriété
        </Button>
      </div>

      <Card className="shadow-lg rounded-xl">
        <CardHeader floated={false} shadow={false} className="rounded-t-xl bg-white border-b border-gray-100">
          <div className="p-6">
            <div className="flex items-center gap-4">
              <div className="w-72">
                <Input
                  label="Rechercher"
                  icon={<MagnifyingGlassIcon className="h-5 w-5 text-gray-500" />}
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="!border-gray-200 focus:!border-gray-900"
                  labelProps={{
                    className: 'text-gray-700',
                  }}
                />
              </div>
            </div>
          </div>
        </CardHeader>
        <CardBody className="overflow-x-auto px-0">
          <table className="w-full min-w-max table-auto text-left">
            <thead>
              <tr>
                {TABLE_HEAD.map((head) => (
                  <th
                    key={head.id}
                    className="border-b border-gray-100 bg-gray-50/50 p-4"
                  >
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-semibold leading-none opacity-70 flex items-center gap-2"
                    >
                      {head.label}
                      {head.id !== 'actions' && (
                        <ChevronUpDownIcon
                          strokeWidth={2.5}
                          className="h-4 w-4 cursor-pointer text-gray-500 hover:text-gray-700 transition-colors"
                        />
                      )}
                    </Typography>
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {TABLE_ROWS.map((property, index) => (
                <tr key={property.id} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-medium"
                    >
                      {property.title}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {property.type}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {property.owner}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {property.address}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <div className="w-max">
                      <Typography
                        variant="small"
                        className={`rounded-full px-3 py-1 font-medium ${property.status === 'disponible' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}
                      >
                        {property.status}
                      </Typography>
                    </div>
                  </td>
                  <td className="p-4">
                    <div className="flex gap-2">
                      <Tooltip content="Modifier">
                        <IconButton variant="text" color="blue-gray" className="hover:bg-gray-100">
                          <PencilIcon className="h-4 w-4" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip content="Supprimer">
                        <IconButton variant="text" color="red" className="hover:bg-red-50">
                          <TrashIcon className="h-4 w-4" />
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