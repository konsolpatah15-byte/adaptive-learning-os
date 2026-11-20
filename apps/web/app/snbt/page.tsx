'use client';
import { useEffect, useState } from 'react';
import { api } from '@/lib/api';

export default function SnbtPage() {
  const [subtests, setSubtests] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.snbtProgress().then(d => { setSubtests(d.subtests || []); setLoading(false); }).catch(() => setLoading(false));
  }, []);

  if (loading) return <div className="text-gray-400">Loading...</div>;

  return (
    <div>
      <h2 className="text-2xl font-bold mb-2">SNBT 2027</h2>
      <p className="text-sm text-gray-500 mb-6">
        7 subtests · Active priority: PU (Penalaran Umum) · Official 2027 info pending
      </p>

      <div className="space-y-4">
        {subtests.map((st: any) => (
          <div key={st.code} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
            <h3 className="font-semibold mb-1">{st.name}</h3>
            <p className="text-xs text-gray-400 mb-3">{st.competencies?.length || 0} competencies</p>
            <div className="space-y-2">
              {st.competencies?.map((c: any) => (
                <div key={c.code} className="flex items-center gap-3">
                  <div className="flex-1 text-sm">{c.name}</div>
                  <div className="w-32 bg-gray-100 rounded-full h-2">
                    <div
                      className={`h-2 rounded-full ${c.mastery < 30 ? 'bg-red-400' : c.mastery < 60 ? 'bg-yellow-400' : 'bg-green-400'}`}
                      style={{ width: `${c.mastery}%` }}
                    />
                  </div>
                  <span className="text-xs font-mono text-gray-500 w-10 text-right">
                    {c.mastery?.toFixed(0)}%
                  </span>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}