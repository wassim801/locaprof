import {
  Card,
  CardBody,
  CardHeader,
  Typography,
} from '@material-tailwind/react';
import {
  UserGroupIcon,
  HomeIcon,
  CalendarDaysIcon,
  ChatBubbleLeftRightIcon,
  CurrencyEuroIcon,
  ArrowTrendingUpIcon,
  ArrowTrendingDownIcon,
} from '@heroicons/react/24/outline';

const statsCards = [
  {
    title: 'Utilisateurs',
    value: '1,234',
    icon: UserGroupIcon,
    change: '+12%',
    trend: 'up',
  },
  {
    title: 'Propriétés',
    value: '456',
    icon: HomeIcon,
    change: '+8%',
    trend: 'up',
  },
  {
    title: 'Réservations',
    value: '789',
    icon: CalendarDaysIcon,
    change: '+15%',
    trend: 'up',
  },
  {
    title: 'Messages',
    value: '2,345',
    icon: ChatBubbleLeftRightIcon,
    change: '+25%',
    trend: 'up',
  },
  {
    title: 'Revenus',
    value: '123,456 €',
    icon: CurrencyEuroIcon,
    change: '+18%',
    trend: 'up',
  },
];

const recentActivity = [
  {
    id: 1,
    type: 'reservation',
    description: 'Nouvelle réservation pour Appartement Paris 15',
    date: '2024-02-10T14:30:00',
  },
  {
    id: 2,
    type: 'property',
    description: 'Nouvelle propriété ajoutée : Villa Marseille',
    date: '2024-02-10T12:15:00',
  },
  {
    id: 3,
    type: 'user',
    description: 'Nouvel utilisateur inscrit : Marie Martin',
    date: '2024-02-10T10:45:00',
  },
];

export default function StatsPage() {
  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('fr-FR', {
      dateStyle: 'short',
      timeStyle: 'short',
    });
  };

  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-2xl font-bold text-gray-900">Tableau de bord</h2>
        <p className="mt-1 text-sm text-gray-600">
          Vue d'ensemble des statistiques de la plateforme
        </p>
      </div>

      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5">
        {statsCards.map((stat) => (
          <Card key={stat.title}>
            <CardBody className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <Typography
                    variant="small"
                    className="font-normal text-blue-gray-600"
                    as="div"
                  >
                    {stat.title}
                  </Typography>
                  <Typography variant="h4" color="blue-gray" className="mt-2">
                    {stat.value}
                  </Typography>
                </div>
                <div
                  className={`rounded-lg p-2 ${
                    stat.trend === 'up'
                      ? 'bg-green-50 text-green-500'
                      : 'bg-red-50 text-red-500'
                  }`}
                >
                  <stat.icon className="h-6 w-6" />
                </div>
              </div>
              <div className="mt-4 flex items-center">
                {stat.trend === 'up' ? (
                  <ArrowTrendingUpIcon className="h-4 w-4 text-green-500" />
                ) : (
                  <ArrowTrendingDownIcon className="h-4 w-4 text-red-500" />
                )}
                <Typography
                  variant="small"
                  className={`ml-1 font-medium ${
                    stat.trend === 'up' ? 'text-green-500' : 'text-red-500'
                  }`}
                >
                  {stat.change}
                </Typography>
                <Typography variant="small" className="ml-2 text-blue-gray-600">
                  vs mois dernier
                </Typography>
              </div>
            </CardBody>
          </Card>
        ))}
      </div>

      <Card>
        <CardHeader
          floated={false}
          shadow={false}
          className="rounded-none bg-transparent"
        >
          <div className="mb-4">
            <Typography variant="h6" color="blue-gray">
              Activité récente
            </Typography>
          </div>
        </CardHeader>
        <CardBody className="px-0">
          <div className="flex flex-col">
            {recentActivity.map((activity) => (
              <div
                key={activity.id}
                className="flex items-center justify-between border-b border-blue-gray-50 px-4 py-3 last:border-b-0"
              >
                <div className="flex items-center gap-4">
                  <div
                    className={`rounded-md p-2 ${
                      activity.type === 'reservation'
                        ? 'bg-blue-50 text-blue-500'
                        : activity.type === 'property'
                        ? 'bg-purple-50 text-purple-500'
                        : 'bg-green-50 text-green-500'
                    }`}
                  >
                    {activity.type === 'reservation' ? (
                      <CalendarDaysIcon className="h-5 w-5" />
                    ) : activity.type === 'property' ? (
                      <HomeIcon className="h-5 w-5" />
                    ) : (
                      <UserGroupIcon className="h-5 w-5" />
                    )}
                  </div>
                  <div>
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal"
                    >
                      {activity.description}
                    </Typography>
                    <Typography
                      variant="small"
                      color="blue-gray"
                      className="font-normal opacity-70"
                    >
                      {formatDate(activity.date)}
                    </Typography>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </CardBody>
      </Card>
    </div>
  );
}