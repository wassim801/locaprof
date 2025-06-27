import { useState } from 'react';
import {
  Typography,
  Card,
  CardBody,
  Switch,
  Button,
} from '@material-tailwind/react';

export default function SettingsPage() {
  const [settings, setSettings] = useState({
    notifications: true,
    darkMode: false,
    autoUpdates: true,
  });

  const toggleSetting = (key: keyof typeof settings) => {
    setSettings(prev => ({ ...prev, [key]: !prev[key] }));
  };

  const handleSave = () => {
    alert('Paramètres sauvegardés !');
    // TODO: Save settings to API
  };

  return (
    <main className="max-w-4xl mx-auto p-6 bg-white rounded shadow">
      <Typography variant="h4" className="mb-6 font-bold text-blue-gray-900">
        Paramètres
      </Typography>

      <Card>
        <CardBody className="space-y-6">
          <div className="flex items-center justify-between">
            <Typography className="font-medium text-blue-gray-700">
              Notifications
            </Typography>
            <Switch
              id="notifications"
              checked={settings.notifications}
              onChange={() => toggleSetting('notifications')}
              ripple={false}
            />
          </div>

          <div className="flex items-center justify-between">
            <Typography className="font-medium text-blue-gray-700">
              Mode sombre
            </Typography>
            <Switch
              id="darkMode"
              checked={settings.darkMode}
              onChange={() => toggleSetting('darkMode')}
              ripple={false}
            />
          </div>

          <div className="flex items-center justify-between">
            <Typography className="font-medium text-blue-gray-700">
              Mises à jour automatiques
            </Typography>
            <Switch
              id="autoUpdates"
              checked={settings.autoUpdates}
              onChange={() => toggleSetting('autoUpdates')}
              ripple={false}
            />
          </div>

          <Button onClick={handleSave} size="lg" className="w-full">
            Enregistrer les modifications
          </Button>
        </CardBody>
      </Card>
    </main>
  );
}
