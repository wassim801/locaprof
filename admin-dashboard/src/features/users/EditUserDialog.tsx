import { useState, useEffect } from 'react';
import {
  Dialog,
  DialogHeader,
  DialogBody,
  DialogFooter,
  Button,
  Input,
  Switch,
  Typography,
} from '@material-tailwind/react';
import { useUpdateUserMutation, type User, type UpdateUserRequest } from './usersApi';

interface EditUserDialogProps {
  open: boolean;
  onClose: () => void;
  user: User | null;
}

export default function EditUserDialog({
  open,
  onClose,
  user,
}: EditUserDialogProps) {
  const [updateUser] = useUpdateUserMutation();
  const [formData, setFormData] = useState<UpdateUserRequest>({
    nom: '',
    prenom: '',
    telephone: '',
    isActive: true,
  });

  useEffect(() => {
    if (user) {
      setFormData({
        nom: user.nom,
        prenom: user.prenom,
        telephone: user.telephone,
        isActive: user.isActive,
      });
    }
  }, [user]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleStatusChange = () => {
    setFormData((prev) => ({ ...prev, isActive: !prev.isActive }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user?.id) return;

    try {
      await updateUser({ id: user.id, data: formData }).unwrap();
      onClose();
    } catch (err) {
      console.error('Erreur lors de la mise à jour:', err);
    }
  };

  if (!user) return null;

  const getRoleDisplay = (role: string) => {
    switch (role) {
      case 'admin': return 'Administrateur';
      case 'proprietaire': return 'Propriétaire';
      case 'locataire': return 'Locataire';
      default: return role;
    }
  };

  return (
    <Dialog open={open} handler={onClose} size="sm">
      <form onSubmit={handleSubmit}>
        <DialogHeader>
          <Typography variant="h5" className="text-blue-gray-900">
            Modifier l'utilisateur
          </Typography>
        </DialogHeader>
        
        <DialogBody className="overflow-y-auto">
          <div className="grid grid-cols-1 gap-4 mb-4">
            <div className="flex items-center space-x-4">
              <div className="flex-1">
                <Input
                  label="Prénom"
                  name="prenom"
                  value={formData.prenom}
                  onChange={handleChange}
                  required
                  crossOrigin={undefined}
                />
              </div>
              <div className="flex-1">
                <Input
                  label="Nom"
                  name="nom"
                  value={formData.nom}
                  onChange={handleChange}
                  required
                  crossOrigin={undefined}
                />
              </div>
            </div>

            <Input
              label="Email"
              name="email"
              type="email"
              value={user.email}
              disabled
              crossOrigin={undefined}
            />

            <Input
              label="Téléphone"
              name="telephone"
              value={formData.telephone}
              onChange={handleChange}
              required
              crossOrigin={undefined}
            />

            <div className="flex items-center justify-between">
              <div>
                <Typography variant="small" className="text-blue-gray-500">
                  Rôle
                </Typography>
                <Typography variant="paragraph" className="font-medium">
                  {getRoleDisplay(user.role)}
                </Typography>
              </div>

              <Switch
                label={
                  <Typography variant="small" className="font-medium">
                    Compte actif
                  </Typography>
                }
                checked={formData.isActive}
                onChange={handleStatusChange}
                crossOrigin={undefined}
              />
            </div>
          </div>
        </DialogBody>

        <DialogFooter className="space-x-2">
          <Button
            variant="outlined"
            color="red"
            onClick={onClose}
            className="mr-2"
          >
            Annuler
          </Button>
          <Button
            type="submit"
            variant="gradient"
            color="blue"
          >
            Enregistrer les modifications
          </Button>
        </DialogFooter>
      </form>
    </Dialog>
  );
}