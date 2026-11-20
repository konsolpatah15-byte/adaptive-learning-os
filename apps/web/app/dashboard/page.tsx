'use client';
import { useEffect, useState } from 'react';
import { api } from '@/lib/api';
import type { DashboardData } from '@/types';
import { BookOpen, Clock, Target, AlertTriangle } from 'lucide-react';

export default function DashboardPage() {
  const [data, setData] = useState<DashboardData | null>(null);
  const [error, setError] = useState('');
  useEffect(() => { api.dashboard().then(setData).catch(e => setError(e.message)); }, []);

  if (error) return <div className="text-red-500">Error: {error}</div>;
  if (!data) return <div className="text-gray-400">Loading...</div>;

  const cards = [
    { icon: Target, label: 'Active Goals', value: data.goals.length, color: 'text-blue-600' },
    { icon: Clock, label: "Today's Tasks", value: data.today_plan.length, color: 'text-green-600' },
    { icon: BookOpen, label: 'Recent Sessions', value: data.recent_sessions.length, color: 'text-purple-600' },
    { icon: AlertTriangle, label: 'Pending Reviews', value: data.upcoming_reviews.length, color: 'text-orange-600' },
  ];

  return (
    <div>
      <h2 className="text-2xl font-bold mb-6">Dashboard</h2>
      <div className="grid grid-cols-4 gap-4 mb-8">
        {cards.map(({ icon: Icon, label, value, color }) => (
          <div key={label} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
            <Icon className={`${color} mb-2`} size={24} />
            <div className="text-2xl font-bold">{value}</div>
            <div className="text-xs text-gray-500">{label}</div>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-2 gap-6">
        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
          <h3 className="font-semibold mb-3">Today's Plan</h3>
          {data.today_plan.length === 0 ? (
            <p className="text-sm text-gray-400">No activities planned for today.</p>
          ) : (
            <ul className="space-y-2">
              {data.today_plan.map(p => (
                <li key={p.id} className="flex justify-between text-sm">
                  <span>{p.start_time} — {p.title}</span>
                  <span className="text-gray-400">{p.minutes}m · {p.track}</span>
                </li>
              ))}
            </ul>
          )}
        </div>

        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
          <h3 className="font-semibold mb-3">Weakest Areas</h3>
          {data.weakest_competencies.length === 0 ? (
            <p className="text-sm text-gray-400">No weaknesses tracked yet.</p>
          ) : (
            <ul className="space-y-2">
              {data.weakest_competencies.map(w => (
                <li key={w.code} className="flex justify-between text-sm">
                  <span>{w.name}</span>
                  <span className={`font-mono ${w.mastery < 30 ? 'text-red-500' : w.mastery < 60 ? 'text-yellow-500' : 'text-green-500'}`}>
                    {w.mastery.toFixed(0)}%
                  </span>
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>

      {data.upcoming_reviews.length > 0 && (
        <div className="mt-6 bg-white rounded-xl p-4 shadow-sm border border-gray-100">
          <h3 className="font-semibold mb-3">Upcoming Reviews</h3>
          <div className="space-y-1">
            {data.upcoming_reviews.map(r => (
              <div key={r.id} className="text-sm text-gray-600 flex justify-between">
                <span>Competency #{r.competency_id}</span>
                <span>Due: {r.due_at?.slice(0, 10)} · Every {r.interval_days}d</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}