import { Card, CardHeader, CardBody, Typography } from '@material-tailwind/react';
import {
  UserGroupIcon,
  BuildingOfficeIcon,
  CalendarIcon,
  BanknotesIcon,
} from '@heroicons/react/24/solid';

const stats = [
  {
    id: 1,
    name: 'Utilisateurs actifs',
    value: '2,451',
    icon: UserGroupIcon,
    iconColor: 'from-blue-400 to-blue-600',
  },
  {
    id: 2,
    name: 'Propriétés listées',
    value: '584',
    icon: BuildingOfficeIcon,
    iconColor: 'from-green-400 to-green-600',
  },
  {
    id: 3,
    name: 'Réservations du mois',
    value: '129',
    icon: CalendarIcon,
    iconColor: 'from-purple-400 to-purple-600',
  },
  {
    id: 4,
    name: 'Revenus mensuels',
    value: '45,250 €',
    icon: BanknotesIcon,
    iconColor: 'from-orange-400 to-orange-600',
  },
];

export default function DashboardPage() {
  return (
    <div className="space-y-10">
      {/* Page Header */}
      <div>
        <h2 className="text-3xl font-extrabold text-gray-900">Tableau de bord</h2>
        <p className="mt-1 text-gray-600">Vue d'ensemble des statistiques de la plateforme</p>
      </div>

      {/* Stat Cards */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
        {stats.map((stat) => (
          <Card
            key={stat.id}
            className="group relative overflow-hidden border border-blue-gray-50 shadow-sm transition hover:shadow-md hover:border-blue-100"
          >
            <CardBody className="p-6 space-y-3">
              <div className="flex items-center justify-between">
              <div
  className={`rounded-full p-2 shadow-md text-white w-12 h-12 flex items-center justify-center bg-gradient-to-tr ${stat.iconColor}`}
  style={{ backgroundImage: `linear-gradient(to top right, var(--tw-gradient-stops))` }}
>
  <stat.icon className="h-6 w-6" />
</div>
              </div>
              <Typography variant="small" className="text-gray-500 font-medium">
                {stat.name}
              </Typography>
              <Typography variant="h4" className="font-bold text-gray-900">
                {stat.value}
              </Typography>
            </CardBody>
          </Card>
        ))}
      </div>

      {/* Other Widgets */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <Card className="border border-blue-gray-50 shadow-sm hover:shadow-md transition">
          <CardHeader
            floated={false}
            shadow={false}
            color="transparent"
            className="p-6 pb-2"
          >
            <Typography variant="h6" color="blue-gray">
              Réservations récentes
            </Typography>
          </CardHeader>
          <CardBody className="px-6 pt-0 text-gray-500 italic">
            Aucune donnée disponible pour le moment.
          </CardBody>
        </Card>

        <Card className="border border-blue-gray-50 shadow-sm hover:shadow-md transition">
          <CardHeader
            floated={false}
            shadow={false}
            color="transparent"
            className="p-6 pb-2"
          >
            <Typography variant="h6" color="blue-gray">
              Activité récente
            </Typography>
          </CardHeader>
          <CardBody className="px-6 pt-0 text-gray-500 italic">
            Aucune activité récente.
          </CardBody>
        </Card>
      </div>
    </div>
  );
}
