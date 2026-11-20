'use client';
import { useEffect, useState } from 'react';
import { api } from '@/lib/api';

export default function AnalyticsPage() {
  const [data, setData] = useState<any>(null);
  const [weaknesses, setWeaknesses] = useState<any[]>([]);

  useEffect(() => {
    api.analytics().then(setData).catch(() => {});
    api.weaknesses().then(d => setWeaknesses(d.weaknesses || [])).catch(() => {});
  }, []);

  return (
    <div>
      <h2 className="text-2xl font-bold mb-6">Analytics</h2>

      <div className="grid grid-cols-3 gap-4 mb-8">
        <div className="bg-white rounded-xl p-4 shadow-sm border">
          <div className="text-3xl font-bold text-brand-600">{data?.total_sessions || 0}</div>
          <div className="text-xs text-gray-500 mt-1">Total Sessions</div>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border">
          <div className="text-3xl font-bold text-orange-600">{data?.pending_reviews || 0}</div>
          <div className="text-xs text-gray-500 mt-1">Pending Reviews</div>
        </div>
        <div className="bg-white rounded-xl p-4 shadow-sm border">
          <div className="text-3xl font-bold text-red-600">{weaknesses.length}</div>
          <div className="text-xs text-gray-500 mt-1">Weak Areas</div>
        </div>
      </div>

      <div className="bg-white rounded-xl p-4 shadow-sm border">
        <h3 className="font-semibold mb-4">Weakest Competencies</h3>
        {weaknesses.length === 0 ? (
          <p className="text-sm text-gray-400">No weakness data yet. Start practicing!</p>
        ) : (
          <div className="space-y-3">
            {weaknesses.map((w: any, i: number) => (
              <div key={i} className="flex items-center gap-4">
                <span className="text-xs text-gray-400 w-6">#{i + 1}</span>
                <div className="flex-1">
                  <div className="text-sm font-medium">{w.name}</div>
                  <div className="text-xs text-gray-400">{w.code} · {w.status}</div>
                </div>
                <div className="w-32 bg-gray-100 rounded-full h-2.5">
                  <div
                    className="h-2.5 rounded-full bg-red-400"
                    style={{ width: `${Math.min(w.mastery, 100)}%` }}
                  />
                </div>
                <span className="text-sm font-mono font-medium text-red-600 w-12">{w.mastery?.toFixed(0)}%</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}