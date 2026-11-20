'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  LayoutDashboard, MessageCircle, BookOpen, Brain,
  BarChart3, AlertTriangle, Calendar, Settings, GraduationCap,
} from 'lucide-react';

const nav = [
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { href: '/tutor', label: 'AI Tutor', icon: MessageCircle },
  { href: '/ielts', label: 'IELTS', icon: GraduationCap },
  { href: '/snbt', label: 'SNBT', icon: Brain },
  { href: '/analytics', label: 'Analytics', icon: BarChart3 },
  { href: '/mistakes', label: 'Mistake Bank', icon: AlertTriangle },
  { href: '/schedule', label: 'Planner', icon: Calendar },
  { href: '/settings', label: 'Settings', icon: Settings },
];

export default function Sidebar() {
  const pathname = usePathname();
  return (
    <aside className="w-56 bg-white border-r border-gray-200 flex flex-col">
      <div className="p-4 border-b border-gray-100">
        <h1 className="text-lg font-bold text-brand-700">ALOS 2.0</h1>
        <p className="text-xs text-gray-400">Adaptive Learning OS</p>
      </div>
      <nav className="flex-1 p-2 space-y-1">
        {nav.map(({ href, label, icon: Icon }) => {
          const active = pathname === href;
          return (
            <Link key={href} href={href}
              className={`flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition-colors ${
                active ? 'bg-brand-50 text-brand-700 font-medium' : 'text-gray-600 hover:bg-gray-50'
              }`}
            >
              <Icon size={18} />
              {label}
            </Link>
          );
        })}
      </nav>
    </aside>
  );
}