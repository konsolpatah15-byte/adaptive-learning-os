'use client';
import { useEffect, useState } from 'react';
import { api } from '@/lib/api';
import type { Competency } from '@/types';

export default function IeltSPage() {
  const [skills, setSkills] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.ieltsProgress().then(d => { setSkills(d.skills || []); setLoading(false); }).catch(() => setLoading(false));
  }, []);

  if (loading) return <div className="text-gray-400">Loading...</div>;

  return (
    <div>
      <h2 className="text-2xl font-bold mb-2">IELTS Academic</h2>
      <p className="text-sm text-gray-500 mb-6">Target: Band 7.0–8.0 · Exam: May 2027 (tentative)</p>

      <div className="space-y-4">
        {skills.map((skill: any) => (
          <div key={skill.subject} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
            <h3 className="font-semibold mb-3">{skill.name}</h3>
            <div className="space-y-2">
              {skill.competencies?.map((c: any) => (
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
                  <span className={`text-xs px-2 py-0.5 rounded-full ${
                    c.status === 'mastered' ? 'bg-green-100 text-green-700' :
                    c.status === 'new' ? 'bg-gray-100 text-gray-500' :
                    'bg-yellow-100 text-yellow-700'
                  }`}>{c.status || 'new'}</span>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}