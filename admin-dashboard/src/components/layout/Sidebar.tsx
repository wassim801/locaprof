import { Link, useLocation } from 'react-router-dom';
import { Typography, IconButton } from '@material-tailwind/react';
import { XMarkIcon } from '@heroicons/react/24/outline';
import {
  HomeIcon,
  UserGroupIcon,
  BuildingOfficeIcon,
  CalendarIcon,
  ChatBubbleLeftRightIcon,
  ChartBarIcon,
} from '@heroicons/react/24/solid';

const navigation = [
  { name: 'Tableau de bord', href: '/', icon: HomeIcon },
  { name: 'Utilisateurs', href: '/users', icon: UserGroupIcon },
  { name: 'Propriétés', href: '/properties', icon: BuildingOfficeIcon },
  { name: 'Réservations', href: '/bookings', icon: CalendarIcon },
  { name: 'Messages', href: '/messages', icon: ChatBubbleLeftRightIcon },
  { name: 'Statistiques', href: '/stats', icon: ChartBarIcon },
];

interface SidebarProps {
  onClose: () => void;
}

export default function Sidebar({ onClose }: SidebarProps) {
  const location = useLocation();

  return (
    <div className="flex h-full flex-col overflow-y-auto bg-white/95 backdrop-blur-sm">
      <div className="flex items-center justify-between px-6 h-16 border-b border-gray-100">
        <Typography variant="h5" color="blue-gray" className="font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
          LocaPro
        </Typography>
        <IconButton
          variant="text"
          color="blue-gray"
          className="lg:hidden hover:bg-blue-gray-50/80 transition-all duration-200 active:scale-95"
          onClick={onClose}
        >
          <XMarkIcon className="h-5 w-5" />
        </IconButton>
      </div>

      <nav className="flex flex-1 flex-col gap-2 p-4">
        {navigation.map((item) => {
          const isActive = location.pathname === item.href;
          return (
            <Link
              key={item.name}
              to={item.href}
              onClick={onClose}
              className={`flex items-center gap-3 rounded-lg px-4 py-2.5 text-sm font-medium transition-all duration-200 ${
                isActive
                  ? 'bg-blue-50/80 text-blue-900 shadow-sm ring-1 ring-blue-900/10'
                  : 'text-blue-gray-700 hover:bg-blue-gray-50/80 hover:text-blue-800'
              }`}
            >
              <item.icon
                className={`h-5 w-5 ${
                  isActive ? 'text-blue-900' : 'text-gray-400 group-hover:text-blue-800'
                }`}
              />
              {item.name}
            </Link>
          );
        })}
      </nav>
    </div>
  );
}
