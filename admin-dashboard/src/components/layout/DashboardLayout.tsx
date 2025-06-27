import { Disclosure, Menu, Transition } from '@headlessui/react'
import { 
  Bars3Icon, 
  XMarkIcon,
  BellIcon,
  UserCircleIcon,
  Cog6ToothIcon,
  ArrowRightOnRectangleIcon,
  HomeIcon,
  UserGroupIcon,
  BuildingOfficeIcon,
  CalendarIcon,
  ChatBubbleLeftRightIcon,
  ChartBarIcon
} from '@heroicons/react/24/outline'
import { Fragment, useState } from 'react'
import { Link, Outlet, useLocation, useNavigate } from 'react-router-dom'

const navigation = [
  { name: 'Tableau de bord', href: '/', icon: HomeIcon },
  { name: 'Utilisateurs', href: '/users', icon: UserGroupIcon },
  { name: 'Propriétés', href: '/properties', icon: BuildingOfficeIcon },
  { name: 'Réservations', href: '/bookings', icon: CalendarIcon },
  { name: 'Messages', href: '/messages', icon: ChatBubbleLeftRightIcon },
  { name: 'Statistiques', href: '/stats', icon: ChartBarIcon },
]

const notifications = [
  {
    id: 1,
    title: 'New booking request',
    description: 'John Doe booked Property #123 for 2 nights',
    time: '10 minutes ago',
    read: false,
    icon: CalendarIcon,
    iconColor: 'text-blue-500'
  },
  {
    id: 2,
    title: 'Payment received',
    description: 'Payment of $350 for booking #4567 has been processed',
    time: '1 hour ago',
    read: false,
    icon: ChartBarIcon,
    iconColor: 'text-green-500'
  },
  {
    id: 3,
    title: 'New message',
    description: 'You have a new message from Sarah Williams',
    time: '3 hours ago',
    read: true,
    icon: ChatBubbleLeftRightIcon,
    iconColor: 'text-purple-500'
  },
  {
    id: 4,
    title: 'Maintenance reminder',
    description: 'Scheduled maintenance for Property #789 tomorrow at 10 AM',
    time: '1 day ago',
    read: true,
    icon: Cog6ToothIcon,
    iconColor: 'text-yellow-500'
  }
]

function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

export default function DashboardLayout() {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const [unreadCount, setUnreadCount] = useState(
    notifications.filter(n => !n.read).length
  )
  const location = useLocation()
  const navigate = useNavigate()

  const markAsRead = (id) => {
    const notification = notifications.find(n => n.id === id)
    if (notification && !notification.read) {
      notification.read = true
      setUnreadCount(unreadCount - 1)
    }
  }

  const markAllAsRead = () => {
    notifications.forEach(n => {
      if (!n.read) {
        n.read = true
      }
    })
    setUnreadCount(0)
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Mobile sidebar */}
      <Transition.Root show={sidebarOpen} as={Fragment}>
        <div className="fixed inset-0 z-40 lg:hidden">
          <Transition.Child
            as={Fragment}
            enter="transition-opacity ease-linear duration-300"
            enterFrom="opacity-0"
            enterTo="opacity-100"
            leave="transition-opacity ease-linear duration-300"
            leaveFrom="opacity-100"
            leaveTo="opacity-0"
          >
            <div className="fixed inset-0 bg-gray-600/80" />
          </Transition.Child>

          <Transition.Child
            as={Fragment}
            enter="transition ease-in-out duration-300 transform"
            enterFrom="-translate-x-full"
            enterTo="translate-x-0"
            leave="transition ease-in-out duration-300 transform"
            leaveFrom="translate-x-0"
            leaveTo="-translate-x-full"
          >
            <div className="relative flex w-72 flex-1 flex-col bg-white shadow-xl">
              <div className="absolute right-0 top-0 -mr-12 pt-2">
                <button
                  type="button"
                  className="ml-1 flex h-10 w-10 items-center justify-center rounded-full focus:outline-none"
                  onClick={() => setSidebarOpen(false)}
                >
                  <XMarkIcon className="h-6 w-6 text-white" />
                </button>
              </div>
              
              <div className="h-16 flex-shrink-0 px-4 flex items-center border-b border-gray-200">
                <h1 className="text-xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
                  LocaPro
                </h1>
              </div>
              
              <div className="flex flex-1 flex-col overflow-y-auto pt-5 pb-4">
                <nav className="flex-1 space-y-1 px-2">
                  {navigation.map((item) => {
                    const current = location.pathname === item.href
                    return (
                      <Link
                        key={item.name}
                        to={item.href}
                        onClick={() => setSidebarOpen(false)}
                        className={classNames(
                          current
                            ? 'bg-blue-50 text-blue-700'
                            : 'text-gray-700 hover:bg-gray-100',
                          'group flex items-center px-2 py-2 text-sm font-medium rounded-md'
                        )}
                      >
                        <item.icon
                          className={classNames(
                            current ? 'text-blue-600' : 'text-gray-500 group-hover:text-gray-700',
                            'mr-3 flex-shrink-0 h-5 w-5'
                          )}
                        />
                        {item.name}
                      </Link>
                    )
                  })}
                </nav>
              </div>
            </div>
          </Transition.Child>
        </div>
      </Transition.Root>

      {/* Static sidebar for desktop */}
      <div className="hidden lg:fixed lg:inset-y-0 lg:flex lg:w-72 lg:flex-col">
        <div className="flex min-h-0 flex-1 flex-col border-r border-gray-200 bg-white">
          <div className="flex h-16 flex-shrink-0 items-center px-4 border-b border-gray-200">
            <h1 className="text-xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
              LocaPro
            </h1>
          </div>
          <div className="flex flex-1 flex-col overflow-y-auto pt-5 pb-4">
            <nav className="flex-1 space-y-1 px-2">
              {navigation.map((item) => {
                const current = location.pathname === item.href
                return (
                  <Link
                    key={item.name}
                    to={item.href}
                    className={classNames(
                      current
                        ? 'bg-blue-50 text-blue-700'
                        : 'text-gray-700 hover:bg-gray-100',
                      'group flex items-center px-2 py-2 text-sm font-medium rounded-md'
                    )}
                  >
                    <item.icon
                      className={classNames(
                        current ? 'text-blue-600' : 'text-gray-500 group-hover:text-gray-700',
                        'mr-3 flex-shrink-0 h-5 w-5'
                      )}
                    />
                    {item.name}
                  </Link>
                )
              })}
            </nav>
          </div>
        </div>
      </div>

      {/* Main content */}
      <div className="lg:pl-72">
        {/* Navbar */}
        <div className="bg-white shadow-sm">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div className="flex h-16 justify-between">
              <div className="flex">
                <div className="flex items-center lg:hidden">
                  <button
                    type="button"
                    className="inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none"
                    onClick={() => setSidebarOpen(true)}
                  >
                    <Bars3Icon className="h-6 w-6" />
                  </button>
                </div>
              </div>
              
              <div className="flex items-center">
                {/* Notifications dropdown */}
                <Menu as="div" className="relative ml-3">
                  <Menu.Button className="relative rounded-full bg-white p-1 text-gray-400 hover:text-gray-500 focus:outline-none">
                    {unreadCount > 0 && (
                      <span className="absolute top-0 right-0 h-2 w-2 rounded-full bg-red-500"></span>
                    )}
                    <BellIcon className="h-6 w-6" />
                  </Menu.Button>
                  <Transition
                    as={Fragment}
                    enter="transition ease-out duration-100"
                    enterFrom="transform opacity-0 scale-95"
                    enterTo="transform opacity-100 scale-100"
                    leave="transition ease-in duration-75"
                    leaveFrom="transform opacity-100 scale-100"
                    leaveTo="transform opacity-0 scale-95"
                  >
                    <Menu.Items className="absolute right-0 z-10 mt-2 w-80 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                      <div className="px-4 py-2 border-b border-gray-200">
                        <div className="flex justify-between items-center">
                          <h3 className="text-lg font-medium text-gray-900">Notifications</h3>
                          {unreadCount > 0 && (
                            <button
                              onClick={markAllAsRead}
                              className="text-sm text-blue-600 hover:text-blue-800"
                            >
                              Mark all as read
                            </button>
                          )}
                        </div>
                      </div>
                      <div className="max-h-96 overflow-y-auto">
                        {notifications.map((notification) => (
                          <Menu.Item key={notification.id}>
                            {({ active }) => (
                              <div
                                onClick={() => markAsRead(notification.id)}
                                className={classNames(
                                  active ? 'bg-gray-50' : '',
                                  !notification.read ? 'bg-blue-50' : '',
                                  'block px-4 py-3 border-b border-gray-100 last:border-b-0'
                                )}
                              >
                                <div className="flex items-start">
                                  <div className={`flex-shrink-0 ${notification.iconColor}`}>
                                    <notification.icon className="h-5 w-5" />
                                  </div>
                                  <div className="ml-3 flex-1">
                                    <p className="text-sm font-medium text-gray-900">
                                      {notification.title}
                                    </p>
                                    <p className="text-sm text-gray-500">
                                      {notification.description}
                                    </p>
                                    <p className="mt-1 text-xs text-gray-400">
                                      {notification.time}
                                    </p>
                                  </div>
                                  {!notification.read && (
                                    <div className="flex-shrink-0 ml-2">
                                      <span className="h-2 w-2 rounded-full bg-blue-500"></span>
                                    </div>
                                  )}
                                </div>
                              </div>
                            )}
                          </Menu.Item>
                        ))}
                      </div>
                      <div className="px-4 py-2 border-t border-gray-200 text-center">
                        <a
                          href="#"
                          className="text-sm font-medium text-blue-600 hover:text-blue-800"
                        >
                          View all notifications
                        </a>
                      </div>
                    </Menu.Items>
                  </Transition>
                </Menu>

                {/* Profile dropdown */}
                <Menu as="div" className="relative ml-3">
                  <Menu.Button className="flex rounded-full bg-white text-sm focus:outline-none">
                    <UserCircleIcon className="h-8 w-8 text-gray-500" />
                  </Menu.Button>
                  <Transition
                    as={Fragment}
                    enter="transition ease-out duration-200"
                    enterFrom="transform opacity-0 scale-95"
                    enterTo="transform opacity-100 scale-100"
                    leave="transition ease-in duration-75"
                    leaveFrom="transform opacity-100 scale-100"
                    leaveTo="transform opacity-0 scale-95"
                  >
                    <Menu.Items className="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                      <Menu.Item>
                        {({ active }) => (
                          <button
                            onClick={() => navigate('/profile')}
                            className={classNames(
                              active ? 'bg-gray-100' : '',
                              'block px-4 py-2 text-sm text-gray-700 w-full text-left'
                            )}
                          >
                            Mon profil
                          </button>
                        )}
                      </Menu.Item>
                      <Menu.Item>
                        {({ active }) => (
                          <button
                            onClick={() => navigate('/settings')}
                            className={classNames(
                              active ? 'bg-gray-100' : '',
                              'block px-4 py-2 text-sm text-gray-700 w-full text-left'
                            )}
                          >
                            Paramètres
                          </button>
                        )}
                      </Menu.Item>
                      <Menu.Item>
                        {({ active }) => (
                          <button
                            onClick={() => navigate('/login')}
                            className={classNames(
                              active ? 'bg-gray-100' : '',
                              'block px-4 py-2 text-sm text-gray-700 w-full text-left'
                            )}
                          >
                            Déconnexion
                          </button>
                        )}
                      </Menu.Item>
                    </Menu.Items>
                  </Transition>
                </Menu>
              </div>
            </div>
          </div>
        </div>

        {/* Page content */}
        <main className="py-6">
          <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  )
}