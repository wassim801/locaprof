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
} from '@material-tailwind/react';
import {
  MagnifyingGlassIcon,
  ChevronUpDownIcon,
  PencilIcon,
  UserPlusIcon,
  TrashIcon,
  CheckCircleIcon,
  XCircleIcon,
} from '@heroicons/react/24/outline';
import CreateUserDialog from './CreateUserDialog';
import EditUserDialog from './EditUserDialog';

const mockUsers = [
  {
    id: '1',
    prenom: 'Alice',
    nom: 'Dupont',
    role: 'admin',
    email: 'alice@example.com',
    telephone: '0123456789',
    isActive: true,
    dateNaissance: '1990-01-15',
    createdAt: '2023-01-10T08:30:00Z',
    updatedAt: '2023-05-20T14:25:00Z'
  },
  {
    id: '2',
    prenom: 'Bob',
    nom: 'Martin',
    role: 'proprietaire',
    email: 'bob@example.com',
    telephone: '0987654321',
    isActive: false,
    dateNaissance: '1985-07-22',
    createdAt: '2023-02-15T10:15:00Z',
    updatedAt: '2023-06-10T09:45:00Z'
  },
  {
    id: '3',
    prenom: 'Charlie',
    nom: 'Durand',
    role: 'locataire',
    email: 'charlie@example.com',
    telephone: '0112233445',
    isActive: true,
    dateNaissance: '1995-03-30',
    createdAt: '2023-03-05T14:20:00Z',
    updatedAt: '2023-04-18T16:30:00Z'
  },
];

const TABLE_HEAD = [
  { id: 'user', label: 'Utilisateur' },
  { id: 'role', label: 'Rôle' },
  { id: 'email', label: 'Email' },
  { id: 'telephone', label: 'Téléphone' },
  { id: 'status', label: 'Statut' },
  { id: 'actions', label: '' },
];

export default function UsersPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [users, setUsers] = useState(mockUsers);

  const filteredUsers = users.filter(
    (user) =>
      user.nom.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.prenom.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.telephone.includes(searchQuery)
  );

  const handleEditUser = (user) => {
    setSelectedUser(user);
    setIsEditDialogOpen(true);
  };

  const handleDeleteUser = (userId) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
      setUsers(users.filter(user => user.id !== userId));
    }
  };

  const handleCreateUser = (newUser) => {
    setUsers([...users, { ...newUser, id: `${users.length + 1}`, isActive: true }]);
    setIsCreateDialogOpen(false);
  };

  const handleUpdateUser = (updatedUser) => {
    setUsers(users.map(user => 
      user.id === updatedUser.id ? { ...user, ...updatedUser } : user
    ));
    setIsEditDialogOpen(false);
  };

  return (
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <div>
          <Typography variant="h2" className="text-2xl font-bold text-gray-900">
            Utilisateurs
          </Typography>
          <Typography variant="small" className="mt-1 text-gray-600">
            Gérez les utilisateurs de la plateforme
          </Typography>
        </div>
        <Button
          className="flex items-center gap-2"
          size="sm"
          color="blue"
          onClick={() => setIsCreateDialogOpen(true)}
        >
          <UserPlusIcon className="h-4 w-4" />
          Ajouter un utilisateur
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
                crossOrigin={undefined}
              />
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
              {filteredUsers.length === 0 ? (
                <tr>
                  <td colSpan={TABLE_HEAD.length} className="p-4 text-center text-gray-500">
                    Aucun utilisateur trouvé.
                  </td>
                </tr>
              ) : (
                filteredUsers.map((user) => (
                  <tr key={user.id} className="hover:bg-blue-gray-50/50">
                    <td className="p-4">
                      <Typography variant="small" color="blue-gray" className="font-normal">
                        {`${user.prenom} ${user.nom}`}
                      </Typography>
                    </td>
                    <td className="p-4">
                      <Typography variant="small" color="blue-gray" className="font-normal">
                        {user.role === 'admin' ? 'Administrateur' : 
                         user.role === 'proprietaire' ? 'Propriétaire' : 'Locataire'}
                      </Typography>
                    </td>
                    <td className="p-4">
                      <Typography variant="small" color="blue-gray" className="font-normal">
                        {user.email}
                      </Typography>
                    </td>
                    <td className="p-4">
                      <Typography variant="small" color="blue-gray" className="font-normal">
                        {user.telephone}
                      </Typography>
                    </td>
                    <td className="p-4">
                      <div className="w-max">
                        <Typography
                          variant="small"
                          className={`flex items-center gap-1 rounded-md px-2 py-1 font-medium ${
                            user.isActive ? 'bg-green-50 text-green-600' : 'bg-red-50 text-red-600'
                          }`}
                        >
                          {user.isActive ? (
                            <>
                              <CheckCircleIcon className="h-4 w-4" />
                              Actif
                            </>
                          ) : (
                            <>
                              <XCircleIcon className="h-4 w-4" />
                              Inactif
                            </>
                          )}
                        </Typography>
                      </div>
                    </td>
                    <td className="p-4">
                      <div className="flex gap-2">
                        <Tooltip content="Modifier">
                          <IconButton
                            variant="text"
                            color="blue-gray"
                            onClick={(e) => {
                              e.stopPropagation();
                              e.preventDefault();
                              handleEditUser(user);
                            }}
                            className="group"
                          >
                            <PencilIcon className="h-4 w-4 text-blue-gray-700 group-hover:text-blue-900" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip content="Supprimer">
                          <IconButton
                            variant="text"
                            color="red"
                            onClick={(e) => {
                              e.stopPropagation();
                              e.preventDefault();
                              handleDeleteUser(user.id);
                            }}
                            className="group"
                          >
                            <TrashIcon className="h-4 w-4 text-red-500 group-hover:text-red-700" />
                          </IconButton>
                        </Tooltip>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </CardBody>
      </Card>

      {/* Dialogs */}
      <CreateUserDialog 
  open={isCreateDialogOpen} 
  onClose={() => setIsCreateDialogOpen(false)}
  onCreateSuccess={() => {
    // Refresh user list or show success message
  }}
/>
      
      <EditUserDialog
  open={isEditDialogOpen}
  onClose={() => setIsEditDialogOpen(false)}
  user={selectedUser}
  onUpdate={handleUpdateUser}
/>
    </div>
  );
}