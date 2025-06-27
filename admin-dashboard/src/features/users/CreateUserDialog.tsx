import { useState } from 'react';
import {
  Dialog,
  DialogHeader,
  DialogBody,
  DialogFooter,
  Button,
  Input,
  Select,
  Option,
  Typography,
} from '@material-tailwind/react';
import { useCreateUserMutation } from './usersApi';

interface CreateUserDialogProps {
  open: boolean;
  onClose: () => void;
  onCreateSuccess?: () => void;
}

export default function CreateUserDialog({ 
  open, 
  onClose,
  onCreateSuccess
}: CreateUserDialogProps) {
  const [createUser, { isLoading }] = useCreateUserMutation();
  const [formData, setFormData] = useState({
    nom: '',
    prenom: '',
    email: '',
    telephone: '',
    role: '',
    password: '',
    dateNaissance: '',
  });
  const [errors, setErrors] = useState<Record<string, string>>({});

  const validateForm = () => {
    const newErrors: Record<string, string> = {};
    if (!formData.nom) newErrors.nom = 'Le nom est requis';
    if (!formData.prenom) newErrors.prenom = 'Le prénom est requis';
    if (!formData.email) {
      newErrors.email = "L'email est requis";
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      newErrors.email = "L'email n'est pas valide";
    }
    if (!formData.telephone) newErrors.telephone = 'Le téléphone est requis';
    if (!formData.role) newErrors.role = 'Le rôle est requis';
    if (!formData.password) {
      newErrors.password = 'Le mot de passe est requis';
    } else if (formData.password.length < 8) {
      newErrors.password = 'Le mot de passe doit contenir au moins 8 caractères';
    }
    if (!formData.dateNaissance) newErrors.dateNaissance = 'La date de naissance est requise';

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: '' }));
    }
  };

  const handleRoleChange = (value: string | undefined) => {
    if (value) {
      setFormData((prev) => ({ ...prev, role: value }));
      if (errors.role) {
        setErrors((prev) => ({ ...prev, role: '' }));
      }
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validateForm()) return;

    try {
      await createUser({
        ...formData,
        isActive: true, // Default to active when creating
      }).unwrap();
      
      // Reset form and close
      setFormData({
        nom: '',
        prenom: '',
        email: '',
        telephone: '',
        role: '',
        password: '',
        dateNaissance: '',
      });
      setErrors({});
      onClose();
      onCreateSuccess?.();
    } catch (err) {
      console.error('Erreur lors de la création:', err);
      setErrors({
        ...errors,
        form: 'Une erreur est survenue lors de la création',
      });
    }
  };

  return (
    <Dialog open={open} handler={onClose} size="md">
      <form onSubmit={handleSubmit}>
        <DialogHeader className="border-b border-blue-gray-100 p-4">
          <Typography variant="h5" color="blue-gray">
            Ajouter un nouvel utilisateur
          </Typography>
        </DialogHeader>
        
        <DialogBody className="p-4 overflow-y-auto">
          <div className="grid grid-cols-1 gap-4">
            <div className="flex gap-4">
              <div className="flex-1">
                <Input
                  label="Prénom"
                  name="prenom"
                  value={formData.prenom}
                  onChange={handleChange}
                  error={!!errors.prenom}
                  crossOrigin={undefined}
                />
                {errors.prenom && (
                  <Typography variant="small" color="red" className="mt-1">
                    {errors.prenom}
                  </Typography>
                )}
              </div>
              <div className="flex-1">
                <Input
                  label="Nom"
                  name="nom"
                  value={formData.nom}
                  onChange={handleChange}
                  error={!!errors.nom}
                  crossOrigin={undefined}
                />
                {errors.nom && (
                  <Typography variant="small" color="red" className="mt-1">
                    {errors.nom}
                  </Typography>
                )}
              </div>
            </div>

            <div>
              <Input
                label="Email"
                name="email"
                type="email"
                value={formData.email}
                onChange={handleChange}
                error={!!errors.email}
                crossOrigin={undefined}
              />
              {errors.email && (
                <Typography variant="small" color="red" className="mt-1">
                  {errors.email}
                </Typography>
              )}
            </div>

            <div className="flex gap-4">
              <div className="flex-1">
                <Input
                  label="Téléphone"
                  name="telephone"
                  value={formData.telephone}
                  onChange={handleChange}
                  error={!!errors.telephone}
                  crossOrigin={undefined}
                />
                {errors.telephone && (
                  <Typography variant="small" color="red" className="mt-1">
                    {errors.telephone}
                  </Typography>
                )}
              </div>
              <div className="flex-1">
                <Input
                  label="Date de naissance"
                  name="dateNaissance"
                  type="date"
                  value={formData.dateNaissance}
                  onChange={handleChange}
                  error={!!errors.dateNaissance}
                  crossOrigin={undefined}
                />
                {errors.dateNaissance && (
                  <Typography variant="small" color="red" className="mt-1">
                    {errors.dateNaissance}
                  </Typography>
                )}
              </div>
            </div>

            <div>
              <Select
                label="Rôle"
                value={formData.role}
                onChange={handleRoleChange}
                error={!!errors.role}
              >
                <Option value="admin">Administrateur</Option>
                <Option value="proprietaire">Propriétaire</Option>
                <Option value="locataire">Locataire</Option>
              </Select>
              {errors.role && (
                <Typography variant="small" color="red" className="mt-1">
                  {errors.role}
                </Typography>
              )}
            </div>

            <div>
              <Input
                label="Mot de passe"
                name="password"
                type="password"
                value={formData.password}
                onChange={handleChange}
                error={!!errors.password}
                crossOrigin={undefined}
              />
              {errors.password && (
                <Typography variant="small" color="red" className="mt-1">
                  {errors.password}
                </Typography>
              )}
            </div>
          </div>

          {errors.form && (
            <Typography variant="small" color="red" className="mt-4">
              {errors.form}
            </Typography>
          )}
        </DialogBody>

        <DialogFooter className="border-t border-blue-gray-100 p-4">
          <Button
            variant="text"
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
            disabled={isLoading}
          >
            {isLoading ? 'Création...' : 'Créer l\'utilisateur'}
          </Button>
        </DialogFooter>
      </form>
    </Dialog>
  );
}