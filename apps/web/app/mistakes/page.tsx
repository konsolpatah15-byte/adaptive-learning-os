'use client';
import { useEffect, useState } from 'react';
import { api } from '@/lib/api';
import type { MistakeEntry } from '@/types';
import { CheckCircle, XCircle } from 'lucide-react';

export default function MistakesPage() {
  const [mistakes, setMistakes] = useState<MistakeEntry[]>([]);
  useEffect(() => { api.mistakes().then(d => setMistakes(d.mistakes || [])).catch(() => {}); }, []);

  const rootColors: Record<string, string> = {
    conceptual: 'bg-red-100 text-red-700',
    calculation: 'bg-orange-100 text-orange-700',
    misreading: 'bg-yellow-100 text-yellow-700',
    vocabulary: 'bg-purple-100 text-purple-700',
    grammar: 'bg-blue-100 text-blue-700',
    logical_reasoning: 'bg-pink-100 text-pink-700',
    careless: 'bg-gray-100 text-gray-700',
  };

  return (
    <div>
      <h2 className="text-2xl font-bold mb-6">Mistake Bank</h2>
      {mistakes.length === 0 ? (
        <div className="bg-white rounded-xl p-8 shadow-sm border text-center">
          <CheckCircle className="mx-auto text-green-400 mb-3" size={40} />
          <p className="text-gray-500">No unresolved mistakes. Great job!</p>
        </div>
      ) : (
        <div className="space-y-3">
          {mistakes.map(m => (
            <div key={m.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
              <div className="flex justify-between items-start mb-2">
                <p className="text-sm font-medium flex-1">{m.question}</p>
                <span className={`text-xs px-2 py-0.5 rounded-full ml-2 ${rootColors[m.root_cause] || 'bg-gray-100'}`}>
                  {m.root_cause}
                </span>
              </div>
              {m.explanation && (
                <p className="text-sm text-gray-500 mt-1 border-l-2 border-brand-300 pl-3">{m.explanation}</p>
              )}
              <div className="flex gap-4 mt-2 text-xs text-gray-400">
                {m.learner_answer && <span>Your answer: {m.learner_answer}</span>}
                {m.correct_answer && <span>Correct: {m.correct_answer}</span>}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}