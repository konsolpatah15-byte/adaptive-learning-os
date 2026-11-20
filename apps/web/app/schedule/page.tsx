'use client';
import { useEffect, useState } from 'react';
import { api } from '@/lib/api';
import type { StudySchedule } from '@/types';
import { Calendar, Clock } from 'lucide-react';

export default function SchedulePage() {
  const [data, setData] = useState<{ plan: StudySchedule[]; pending_reviews: any[]; date: string } | null>(null);
  useEffect(() => { api.schedule().then(setData).catch(() => {}); }, []);

  return (
    <div>
      <h2 className="text-2xl font-bold mb-6">Study Planner</h2>

      <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 mb-6">
        <div className="flex items-center gap-2 mb-3">
          <Calendar size={18} className="text-brand-500" />
          <span className="font-medium">{data?.date || 'Today'}</span>
          <span className="text-xs text-gray-400">
            {data?.pending_reviews?.length || 0} reviews pending
          </span>
        </div>

        {!data?.plan || data.plan.length === 0 ? (
          <p className="text-sm text-gray-400 py-4 text-center">No activities scheduled for today.</p>
        ) : (
          <div className="space-y-2">
            {data.plan.map(p => (
              <div key={p.id} className="flex items-center gap-3 p-3 rounded-lg border border-gray-50 hover:bg-gray-50">
                <div className="w-12 text-center">
                  <Clock size={16} className="mx-auto text-gray-400" />
                  <span className="text-xs text-gray-500">{p.start_time}</span>
                </div>
                <div className="flex-1">
                  <div className="text-sm font-medium">{p.title}</div>
                  <div className="text-xs text-gray-400 flex gap-2">
                    <span className={`px-1.5 py-0.5 rounded text-xs ${
                      p.track === 'ielts' ? 'bg-blue-100 text-blue-700' :
                      p.track === 'snbt' ? 'bg-purple-100 text-purple-700' :
                      p.track === 'review' ? 'bg-orange-100 text-orange-700' :
                      'bg-gray-100 text-gray-600'
                    }`}>{p.track}</span>
                    <span>{p.activity}</span>
                    <span>{p.minutes}m</span>
                  </div>
                </div>
                <span className={`text-xs px-2 py-0.5 rounded ${
                  p.status === 'done' ? 'bg-green-100 text-green-700' :
                  p.status === 'planned' ? 'bg-gray-100 text-gray-600' :
                  'bg-yellow-100 text-yellow-700'
                }`}>{p.status}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}