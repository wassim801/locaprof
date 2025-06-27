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
  Chip,
  Avatar,
} from '@material-tailwind/react';
import {
  MagnifyingGlassIcon,
  ChevronUpDownIcon,
  ChatBubbleLeftRightIcon,
  EyeIcon,
  ArchiveBoxIcon,
} from '@heroicons/react/24/outline';

const TABLE_HEAD = [
  { id: 'sender', label: 'Expéditeur' },
  { id: 'receiver', label: 'Destinataire' },
  { id: 'subject', label: 'Sujet' },
  { id: 'date', label: 'Date' },
  { id: 'status', label: 'Statut' },
  { id: 'actions', label: '' },
];

// Données de test en attendant l'intégration de l'API
const TABLE_ROWS = [
  {
    id: '1',
    sender: {
      name: 'Marie Martin',
      avatar: 'https://ui-avatars.com/api/?name=Marie+Martin',
    },
    receiver: {
      name: 'Jean Dupont',
      avatar: 'https://ui-avatars.com/api/?name=Jean+Dupont',
    },
    subject: 'Question sur la réservation',
    date: '2024-02-10T14:30:00',
    status: 'non lu',
  },
  // Ajouter plus de données de test
];

export default function MessagesPage() {
  const [searchQuery, setSearchQuery] = useState('');

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('fr-FR', {
      dateStyle: 'short',
      timeStyle: 'short',
    });
  };

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-gray-900">Messages</h2>
          <p className="mt-1 text-sm text-gray-600">
            Gérez les communications entre utilisateurs
          </p>
        </div>
        <Button className="flex items-center gap-2" size="sm" color="blue">
          <ChatBubbleLeftRightIcon className="h-4 w-4" />
          Nouveau message
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
              {TABLE_ROWS.map((message) => (
                <tr key={message.id}>
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <Avatar
                        src={message.sender.avatar}
                        alt={message.sender.name}
                        size="sm"
                      />
                      <Typography
                        variant="small"
                        color="blue-gray"
                        className="font-normal"
                      >
                        {message.sender.name}
                      </Typography>
                    </div>
                  </td>
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <Avatar
                        src={message.receiver.avatar}
                        alt={message.receiver.name}
                        size="sm"
                      />
                      <Typography
                        variant="small"
                        color="blue-gray"
                        className="font-normal"
                      >
                        {message.receiver.name}
                      </Typography>
                    </div>
                  </td>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {message.subject}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {formatDate(message.date)}
                    </Typography>
                  </td>
                  <td className="p-4">
                    <div className="w-max">
                      <Chip
                        variant="ghost"
                        size="sm"
                        value={message.status}
                        color={message.status === 'non lu' ? 'blue-gray' : 'green'}
                      />
                    </div>
                  </td>
                  <td className="p-4">
                    <div className="flex gap-2">
                      <Tooltip content="Voir le message">
                        <IconButton variant="text" color="blue-gray">
                          <EyeIcon className="h-4 w-4" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip content="Archiver">
                        <IconButton variant="text" color="blue-gray">
                          <ArchiveBoxIcon className="h-4 w-4" />
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